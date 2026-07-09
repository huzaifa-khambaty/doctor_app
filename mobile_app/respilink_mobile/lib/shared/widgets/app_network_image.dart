import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:respilink_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Detects the source type of the given [imageUrl].
enum _ImageSourceType { network, file, asset, svg }

_ImageSourceType _detectSourceType(String imageUrl) {
  final lower = imageUrl.toLowerCase();

  // SVG detection — must come before file/asset checks
  // because a file or asset path can also end with .svg
  final isSvg = lower.endsWith('.svg');

  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return isSvg ? _ImageSourceType.svg : _ImageSourceType.network;
  }

  if (imageUrl.startsWith('/') || imageUrl.startsWith('file://')) {
    // Absolute file-system path → File image (or SVG from file)
    return isSvg ? _ImageSourceType.svg : _ImageSourceType.file;
  }

  // Anything else is treated as a Flutter asset path
  return isSvg ? _ImageSourceType.svg : _ImageSourceType.asset;
}

/// A unified image widget that accepts a single [imageUrl] and automatically
/// handles:
///   • Network images  (http / https)  — cached via CachedNetworkImage
///   • File images     (absolute path or file://)
///   • Asset images    (assets/…)
///   • SVG images      (any source, detected by .svg extension)
///
/// All sizing, fit, placeholder, and error parameters are forwarded to the
/// appropriate underlying widget so the caller never needs to know which
/// renderer is being used.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.headers,
    this.isCircle = false,
  });

  /// The image source. Can be:
  ///   - A network URL      : `https://example.com/image.png`
  ///   - An absolute path   : `/storage/emulated/0/Pictures/photo.jpg`
  ///   - A Flutter asset    : `assets/images/logo.png`
  ///   - Any SVG            : detected automatically by `.svg` extension
  final String imageUrl;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;

  /// Widget shown while the image is loading (network/file).
  /// Defaults to a shimmer-like [CircularProgressIndicator].
  final Widget? placeholder;

  /// Widget shown when the image fails to load.
  /// Defaults to a broken-image icon.
  final Widget? errorWidget;

  final Duration placeholderFadeInDuration;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  /// Downscale hint for the image cache (pixels). Reduces memory footprint.
  final int? memCacheWidth;
  final int? memCacheHeight;

  /// Custom cache key for [CachedNetworkImage].
  final String? cacheKey;

  /// Optional HTTP headers for network requests.
  final Map<String, String>? headers;

  /// If true, clips the image into a circle using [BoxShape.circle].
  /// Works for all source types. Width and height should be equal for best results.
  final bool isCircle;

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  Widget _defaultPlaceholder(BuildContext context) =>
      placeholder ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );

  Widget _defaultError(BuildContext context) =>
      errorWidget ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          );

  // ─────────────────────────────────────────────────────────────────────────
  // Builders
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildNetwork(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment as Alignment,
      cacheKey: cacheKey,
      httpHeaders: headers,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholderFadeInDuration: placeholderFadeInDuration,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: (context, url) => _defaultPlaceholder(context),
      errorWidget: (context, url, error) => _defaultError(context),
    );
  }

  Widget _buildFile(BuildContext context) {
    final path = imageUrl.startsWith('file://')
        ? imageUrl.replaceFirst('file://', '')
        : imageUrl;

    final file = File(path);

    return file.existsSync()
        ? Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      cacheWidth: memCacheWidth,
      cacheHeight: memCacheHeight,
      errorBuilder: (context, error, stackTrace) =>
          _defaultError(context),
    )
        : _defaultError(context);
  }

  Widget _buildAsset(BuildContext context) {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      cacheWidth: memCacheWidth,
      cacheHeight: memCacheHeight,
      errorBuilder: (context, error, stackTrace) => _defaultError(context),
    );
  }

  Widget _buildSvg(BuildContext context) {
    // Determine SVG source
    final BytesLoader loader;

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      loader = SvgNetworkLoader(imageUrl);
    } else if (imageUrl.startsWith('/') ||
        imageUrl.startsWith('file://')) {
      final path = imageUrl.replaceFirst('file://', '');
      loader = SvgFileLoader(File(path));
    } else {
      loader = SvgAssetLoader(imageUrl);
    }

    return SvgPicture(
      loader,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _defaultPlaceholder(context),
    );
  }
  Widget _applyCircle(Widget child) {
    if (!isCircle) return child;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 2.0, // Adjust thickness as needed
        ),
      ),
      child: ClipOval(
        child: child,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) return _defaultError(context);

    final Widget image = switch (_detectSourceType(imageUrl)) {
      _ImageSourceType.network => _buildNetwork(context),
      _ImageSourceType.file    => _buildFile(context),
      _ImageSourceType.asset   => _buildAsset(context),
      _ImageSourceType.svg     => _buildSvg(context),
    };

    return _applyCircle(image);
  }
}
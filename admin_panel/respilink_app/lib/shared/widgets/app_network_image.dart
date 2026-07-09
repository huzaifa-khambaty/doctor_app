import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    this.imageUrl,
    this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.cacheKey,
    this.headers,
    this.memCacheWidth,
    this.memCacheHeight,
    this.isCircle = false,
  });

  /// Network URL or Asset path
  final String? imageUrl;

  /// Image bytes (Image Picker, API, etc.)
  final Uint8List? bytes;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Alignment alignment;

  final Widget? placeholder;
  final Widget? errorWidget;

  final int? memCacheWidth;
  final int? memCacheHeight;

  final String? cacheKey;
  final Map<String, String>? headers;

  final bool isCircle;

  Widget _loading() {
    return placeholder ??
        SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
  }

  Widget _error() {
    return errorWidget ??
        SizedBox(
          width: width,
          height: height,
          child:  Center(
            child: Icon(
              Icons.person,
              color: Colors.grey,
              size: (width ?? 0) * .6,
            ),
          ),
        );
  }

  Widget _buildImage() {
    if (bytes != null) {
      return Image.memory(
        bytes!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        cacheWidth: memCacheWidth,
        cacheHeight: memCacheHeight,
        errorBuilder: (_, error, stacktrace) => _error(),
      );
    }

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _error();
    }

    final url = imageUrl!;
    final isNetwork = url.startsWith('http');
    final isSvg = url.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return isNetwork
          ? SvgPicture.network(
              url,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              colorFilter: color == null
                  ? null
                  : ColorFilter.mode(
                      color!,
                      colorBlendMode ?? BlendMode.srcIn,
                    ),
              placeholderBuilder: (_) => _loading(),
            )
          : SvgPicture.asset(
              url,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              colorFilter: color == null
                  ? null
                  : ColorFilter.mode(
                      color!,
                      colorBlendMode ?? BlendMode.srcIn,
                    ),
              placeholderBuilder: (_) => _loading(),
            );
    }

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        cacheKey: cacheKey,
        httpHeaders: headers,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        placeholder: (_, error) => _loading(),
        errorWidget: (_, error, stacktrace) => _error(),
      );
    }

    return Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      cacheWidth: memCacheWidth,
      cacheHeight: memCacheHeight,
      errorBuilder: (_, error, stacktrace) => _error(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildImage();

    if (!isCircle) return child;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: child,
      ),
    );
  }
}
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../exports.dart';

const List<String> _directVideoExtensions = [
  '.mp4',
  '.mov',
  '.m3u8',
  '.webm',
  '.mkv',
  '.avi',
  '.3gp',
];

/// Renders a video preview for [videoUrl] right after the article body.
/// - Direct video files (mp4/mov/m3u8/etc.) play inline.
/// - Any other link (YouTube, Vimeo, Zoom recordings, ...) shows a
///   tap-to-open card that launches the link externally.
/// Silently renders nothing if [videoUrl] is missing/blank/unparsable so
/// there is never a crash or broken UI for content without a webinar video.
class ArticleVideoPreview extends StatelessWidget {
  final String? videoUrl;
  final String? thumbnailUrl;

  const ArticleVideoPreview({super.key, this.videoUrl, this.thumbnailUrl});

  bool _looksLikeDirectVideo(Uri uri) {
    final path = uri.path.toLowerCase();
    return _directVideoExtensions.any((ext) => path.endsWith(ext));
  }

  @override
  Widget build(BuildContext context) {
    final url = videoUrl?.trim();
    if (url == null || url.isEmpty) return const SizedBox.shrink();

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _looksLikeDirectVideo(uri)
            ? _InlineVideoPlayer(url: url, thumbnailUrl: thumbnailUrl)
            : _ExternalVideoCard(url: url, thumbnailUrl: thumbnailUrl),
      ),
    );
  }
}

class _InlineVideoPlayer extends StatefulWidget {
  final String url;
  final String? thumbnailUrl;

  const _InlineVideoPlayer({required this.url, this.thumbnailUrl});

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      _controller = controller;
      _initializeFuture = controller.initialize().catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
    } catch (_) {
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null) {
      return _ExternalVideoCard(url: widget.url, thumbnailUrl: widget.thumbnailUrl);
    }

    return FutureBuilder<void>(
      future: _initializeFuture,
      builder: (context, snapshot) {
        final controller = _controller;
        if (_hasError ||
            snapshot.hasError ||
            controller == null ||
            !controller.value.isInitialized) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _ExternalVideoCard(url: widget.url, thumbnailUrl: widget.thumbnailUrl);
          }
          return Container(
            color: AppColors.black,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }

        return GestureDetector(
          onTap: _togglePlay,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
              AnimatedOpacity(
                opacity: controller.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(14.r),
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  colors: VideoProgressColors(
                    playedColor: AppColors.primary,
                    bufferedColor: Colors.white.withValues(alpha: 0.4),
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExternalVideoCard extends StatelessWidget {
  final String url;
  final String? thumbnailUrl;

  const _ExternalVideoCard({required this.url, this.thumbnailUrl});

  Future<void> _openExternally(BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the video link.', isError: true);
      }
    } catch (_) {
      if (context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the video link.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailUrl?.trim();

    return GestureDetector(
      onTap: () => _openExternally(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumb != null && thumb.isNotEmpty)
            AppNetworkImage(
              imageUrl: thumb.startsWith('http') ? thumb : "${AppConstants.imagePath}$thumb",
              fit: BoxFit.cover,
              errorWidget: Container(color: AppColors.black),
            )
          else
            Container(color: AppColors.black),
          Container(color: Colors.black.withValues(alpha: 0.35)),
          Center(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              padding: EdgeInsets.all(14.r),
              child: Icon(Icons.play_arrow, color: AppColors.primary, size: 32.sp),
            ),
          ),
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 10.h,
            child: Row(
              children: [
                Icon(Icons.open_in_new, color: Colors.white, size: 14.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: AppText.small(
                    label: 'Watch video',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:url_launcher/url_launcher.dart';

import '../../../../exports.dart';

/// Renders the article's `external_url` and `external_links` as tappable
/// rows that open in the device's browser/app. Renders nothing if both are
/// missing/empty, and never throws — a failed launch just shows a snackbar.
class ArticleExternalLinks extends StatelessWidget {
  final String? externalUrl;
  final List<String>? externalLinks;

  const ArticleExternalLinks({super.key, this.externalUrl, this.externalLinks});

  List<String> get _links {
    final url = externalUrl?.trim();
    final others = (externalLinks ?? const <String>[])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    return <String>{
      if (url != null && url.isNotEmpty) url,
      ...others,
    }.toList();
  }

  Future<void> _open(BuildContext context, String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        SnackbarUtil.showSnackbar(message: 'Invalid link.', isError: true);
        return;
      }

      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the link.', isError: true);
      }
    } catch (_) {
      if (context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the link.', isError: true);
      }
    }
  }

  IconData _iconFor(String url) {
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    if (host.contains('youtube') || host.contains('youtu.be')) {
      return Icons.play_circle_outline;
    }
    return Icons.link;
  }

  String _labelFor(String url) {
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    return host.isNotEmpty ? host.replaceFirst('www.', '') : url;
  }

  @override
  Widget build(BuildContext context) {
    final links = _links;
    if (links.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.small(
          label: 'External Resources',
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
        SizedBox(height: 10.h),
        for (final link in links) ...[
          _ExternalLinkTile(
            icon: _iconFor(link),
            label: _labelFor(link),
            url: link,
            onTap: () => _open(context, link),
          ),
          SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _ExternalLinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final VoidCallback onTap;

  const _ExternalLinkTile({
    required this.icon,
    required this.label,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.fieldColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: AppText.small(
                label: label,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.open_in_new, color: AppColors.grey, size: 14.sp),
          ],
        ),
      ),
    );
  }
}

import 'package:respilink_mobile/shared/utils/html_utils.dart';

import '../../exports.dart';

enum _BlockTag { h1, h2, h3, h4, h5, h6, p, li, img }

class _HtmlBlock {
  final _BlockTag tag;
  final String innerHtml;
  final String? imageSrc;

  const _HtmlBlock(this.tag, this.innerHtml, {this.imageSrc});
}

/// Renders simple, well-formed HTML content blocks (headings, paragraphs,
/// list items, inline bold/italic text, and images) without a full HTML/CSS
/// engine. Images are tappable and open in a zoomable full-screen viewer.
///
/// Pass [maxLines] for a collapsed plain-text preview (e.g. a card teaser);
/// omit it to render the full block structure (e.g. a detail page body).
class AppHtmlText extends StatelessWidget {
  final String html;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const AppHtmlText({
    super.key,
    required this.html,
    this.color,
    this.fontSize,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  /// Matches either a block tag (`<p>…</p>`, `<h1>…</h1>`, `<li>…</li>`) or a
  /// standalone `<img src="…">`, in document order, so both interleave
  /// correctly regardless of which comes first.
  static final RegExp _contentPattern = RegExp(
    "<(h[1-6]|p|li)[^>]*>([\\s\\S]*?)<\\/\\1>|<img[^>]*?src=[\"']([^\"']+)[\"'][^>]*?\\/?>",
    caseSensitive: false,
  );
  static final RegExp _inlinePattern = RegExp(
    r'<(strong|b|em|i)[^>]*>([\s\S]*?)<\/\1>',
    caseSensitive: false,
  );

  List<_HtmlBlock> _parseBlocks(String source) {
    final normalized = source.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );

    final matches = _contentPattern.allMatches(normalized).toList();
    if (matches.isEmpty) {
      // No recognised block tags — treat the whole string as one paragraph.
      return [_HtmlBlock(_BlockTag.p, normalized)];
    }

    return [
      for (final match in matches)
        if (match.group(3) != null)
          _HtmlBlock(_BlockTag.img, '', imageSrc: match.group(3))
        else
          _HtmlBlock(
            _BlockTag.values.firstWhere(
              (t) => t.name == match.group(1)!.toLowerCase(),
              orElse: () => _BlockTag.p,
            ),
            match.group(2) ?? '',
          ),
    ];
  }

  List<InlineSpan> _parseInline(String innerHtml, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final match in _inlinePattern.allMatches(innerHtml)) {
      if (match.start > cursor) {
        final plain = innerHtml.substring(cursor, match.start);
        spans.add(TextSpan(text: HtmlUtils.stripTags(plain), style: baseStyle));
      }

      final tag = match.group(1)!.toLowerCase();
      final isEmphasis = tag == 'em' || tag == 'i';
      spans.add(
        TextSpan(
          text: HtmlUtils.stripTags(match.group(2)),
          style: baseStyle.copyWith(
            fontWeight: isEmphasis ? baseStyle.fontWeight : FontWeight.bold,
            fontStyle: isEmphasis ? FontStyle.italic : baseStyle.fontStyle,
          ),
        ),
      );

      cursor = match.end;
    }

    if (cursor < innerHtml.length) {
      spans.add(
        TextSpan(
          text: HtmlUtils.stripTags(innerHtml.substring(cursor)),
          style: baseStyle,
        ),
      );
    }

    return spans.isEmpty
        ? [TextSpan(text: HtmlUtils.stripTags(innerHtml), style: baseStyle)]
        : spans;
  }

  TextStyle _styleFor(_BlockTag tag) {
    final base = TextStyle(
      fontFamily: AppConstants.fontFamily,
      color: color ?? AppColors.black,
      fontSize: fontSize,
    );

    return switch (tag) {
      _BlockTag.h1 => base.copyWith(
          fontSize: fontSize ?? 20.sp,
          fontWeight: FontWeight.bold,
        ),
      _BlockTag.h2 => base.copyWith(
          fontSize: fontSize ?? 18.sp,
          fontWeight: FontWeight.bold,
        ),
      _BlockTag.h3 ||
      _BlockTag.h4 ||
      _BlockTag.h5 ||
      _BlockTag.h6 => base.copyWith(
          fontSize: fontSize ?? 16.sp,
          fontWeight: FontWeight.bold,
        ),
      _BlockTag.p => base.copyWith(fontSize: fontSize ?? 13.sp, height: 1.5),
      _BlockTag.li => base.copyWith(fontSize: fontSize ?? 13.sp, height: 1.5),
      _BlockTag.img => base,
    };
  }

  void _openImageViewer(BuildContext context, String src) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(
                child: AppNetworkImage(imageUrl: src, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: AppColors.white, size: 20.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (maxLines != null) {
      return Text(
        HtmlUtils.stripTags(html),
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: AppConstants.fontFamily,
          color: color ?? AppColors.black,
          fontSize: fontSize ?? 13.sp,
        ),
      );
    }

    final blocks = _parseBlocks(html);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) SizedBox(height: blocks[i].tag == _BlockTag.img ? 12.h : 8.h),
          if (blocks[i].tag == _BlockTag.img)
            GestureDetector(
              onTap: () => _openImageViewer(context, blocks[i].imageSrc!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppNetworkImage(
                  imageUrl: blocks[i].imageSrc!,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (blocks[i].tag == _BlockTag.li)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h, right: 6.w),
                  child: Icon(
                    Icons.circle,
                    size: 5.sp,
                    color: color ?? AppColors.black,
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: _parseInline(
                        blocks[i].innerHtml,
                        _styleFor(blocks[i].tag),
                      ),
                    ),
                    textAlign: textAlign,
                  ),
                )
              ],
            )
          else
            Text.rich(
              TextSpan(
                children: _parseInline(
                  blocks[i].innerHtml,
                  _styleFor(blocks[i].tag),
                ),
              ),
              textAlign: textAlign,
            ),
        ],
      ],
    );
  }
}

/// Lightweight helpers for backend-authored HTML content blocks (article /
/// quiz descriptions). Not a full HTML/CSS engine — just enough to render
/// simple, well-formed markup (headings, paragraphs, bold/italic, lists)
/// without pulling in a heavyweight HTML rendering package.
class HtmlUtils {
  HtmlUtils._();

  static final RegExp _tagPattern = RegExp(r'<[^>]*>');
  static final RegExp _whitespacePattern = RegExp(r'\s+');

  /// Strips all tags and unescapes entities, collapsing whitespace into a
  /// single line — used for plain-text previews/excerpts.
  static String stripTags(String? html) {
    if (html == null || html.isEmpty) return '';

    final withoutTags = html.replaceAll(_tagPattern, ' ');
    final unescaped = unescapeEntities(withoutTags);
    return unescaped.replaceAll(_whitespacePattern, ' ').trim();
  }

  static String unescapeEntities(String text) {
    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
  }
}

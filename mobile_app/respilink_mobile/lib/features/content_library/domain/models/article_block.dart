enum ArticleBlockType { paragraph, heading, insight, interactiveWidget }

class ArticleBlock {
  final ArticleBlockType type;
  final String text;

  /// Paragraph-only: a phrase within [text] to render bold and highlighted.
  final String? highlightPhrase;

  /// Insight-only: the callout's bold title, e.g. "Key Clinical Insight".
  final String? insightTitle;

  /// Interactive-widget-only: the CTA button label, e.g. "Launch Viewer".
  final String? ctaLabel;

  const ArticleBlock.paragraph(this.text, {this.highlightPhrase})
    : type = ArticleBlockType.paragraph,
      insightTitle = null,
      ctaLabel = null;

  const ArticleBlock.heading(this.text)
    : type = ArticleBlockType.heading,
      highlightPhrase = null,
      insightTitle = null,
      ctaLabel = null;

  const ArticleBlock.insight(this.text, {this.insightTitle = 'Key Clinical Insight'})
    : type = ArticleBlockType.insight,
      highlightPhrase = null,
      ctaLabel = null;

  const ArticleBlock.interactiveWidget(this.text, {this.ctaLabel = 'Launch Viewer'})
    : type = ArticleBlockType.interactiveWidget,
      highlightPhrase = null,
      insightTitle = null;
}

import 'package:respilink_mobile/features/content_library/domain/models/article_block.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_heading_block.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_insight_callout.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_interactive_widget_block.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_paragraph_block.dart';

import '../../../../exports.dart';

class ArticleBody extends StatelessWidget {
  final List<ArticleBlock> blocks;
  final ValueChanged<ArticleBlock>? onInteractiveWidgetLaunch;

  const ArticleBody({
    super.key,
    required this.blocks,
    this.onInteractiveWidgetLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) ...[
          switch (block.type) {
            ArticleBlockType.paragraph => ArticleParagraphBlock(
                text: block.text,
                highlightPhrase: block.highlightPhrase,
              ),
            ArticleBlockType.heading => ArticleHeadingBlock(text: block.text),
            ArticleBlockType.insight => ArticleInsightCallout(
                title: block.insightTitle ?? 'Key Clinical Insight',
                quote: block.text,
              ),
            ArticleBlockType.interactiveWidget => ArticleInteractiveWidgetBlock(
                title: block.text,
                ctaLabel: block.ctaLabel ?? 'Launch Viewer',
                onLaunch: () => onInteractiveWidgetLaunch?.call(block),
              ),
          },
          SizedBox(height: 16.h),
        ],
      ],
    );
  }
}

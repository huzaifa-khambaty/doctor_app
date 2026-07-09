import 'package:respilink_mobile/features/content_library/domain/models/related_article_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/related_article_card.dart';

import '../../../../exports.dart';

class RelatedArticlesSection extends StatelessWidget {
  final List<RelatedArticleModel> articles;
  final ValueChanged<RelatedArticleModel>? onArticleTap;

  const RelatedArticlesSection({
    super.key,
    required this.articles,
    this.onArticleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          label: 'Related Clinical Content',
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 12.h),
        for (final article in articles) ...[
          RelatedArticleCard(
            article: article,
            onTap: () => onArticleTap?.call(article),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

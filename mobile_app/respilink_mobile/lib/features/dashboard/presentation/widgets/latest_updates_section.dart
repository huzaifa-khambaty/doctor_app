import 'package:respilink_mobile/features/dashboard/domain/models/article_update_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/update_article_card.dart';

import '../../../../exports.dart';

class LatestUpdatesSection extends StatelessWidget {
  final List<ArticleUpdateModel> articles;
  final ValueChanged<ArticleUpdateModel>? onArticleTap;

  const LatestUpdatesSection({
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
          label: 'Latest updates',
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 4.h),
        if (articles.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppText.small(
              label: 'No updates yet.',
              color: AppColors.grey,
              fontSize: 12.sp,
            ),
          )
        else
          ...articles.map(
            (article) => UpdateArticleCard(
              article: article,
              onTap: onArticleTap != null ? () => onArticleTap!(article) : null,
            ),
          ),
      ],
    );
  }
}

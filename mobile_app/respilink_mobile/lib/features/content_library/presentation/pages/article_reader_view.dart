import 'package:respilink_mobile/features/content_library/domain/models/article_block.dart';
import 'package:respilink_mobile/features/content_library/domain/models/article_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/related_article_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_author_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_body.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_bookmark_fab.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_engagement_bar.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_header_image.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_share_fab.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_tag_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_tags_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_title.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/related_articles_section.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the article API is wired up.
const _article = ArticleModel(
  title: 'Advanced Pulmonary Rehabilitation Techniques in COPD Management',
  tag: 'CLINICAL GUIDELINE',
  readTime: '8 min read',
  bannerImage: 'copd.png',
  authorName: 'Dr. Sarah Chen, MD',
  publishedLabel: 'Published Oct 24, 2023 • Peer Reviewed',
  blocks: [
    ArticleBlock.paragraph(
      'Pulmonary rehabilitation (PR) remains a cornerstone in the comprehensive management of patients with chronic obstructive pulmonary disease (COPD). While traditional models focus on treadmill and cycle ergometry, emerging evidence suggests that integrative high-intensity interval training (HIIT) combined with specialized breathing techniques can significantly enhance functional outcomes.',
      highlightPhrase: 'integrative high-intensity interval training (HIIT)',
    ),
    ArticleBlock.heading('The Shift Toward HIIT'),
    ArticleBlock.paragraph(
      'Recent clinical trials have demonstrated that HIIT may provide superior physiological adaptations compared to continuous moderate-intensity training. By allowing patients to reach higher ventilatory thresholds for shorter durations, we reduce the total burden of dyspnea while maximizing peripheral muscle output.',
    ),
    ArticleBlock.insight(
      'Patients implementing HIIT showed a 15% greater improvement in 6-minute walk distance (6MWD) compared to traditional aerobic training protocols over a 12-week period.',
    ),
    ArticleBlock.paragraph(
      "Beyond exercise, the psychological aspect of rehabilitation cannot be understated. Gamification of breathing exercises—now being pioneered in RespiLink's new Quiz modules—has shown a 40% increase in patient adherence to home-based exercise prescriptions.",
    ),
    ArticleBlock.heading('Integration of Digital Monitoring'),
    ArticleBlock.paragraph(
      'The modern clinician now has access to real-time data streaming from wearable devices. Tracking SpO2 levels and respiratory rates during active phases allows for dynamic intensity adjustment, ensuring patient safety while pushing the therapeutic ceiling.',
    ),
    ArticleBlock.interactiveWidget(
      'Interactive Lung Capacity Model',
      ctaLabel: 'Launch Viewer',
    ),
    ArticleBlock.paragraph(
      'In conclusion, pulmonary rehabilitation is evolving from a standardized one-size-fits-all model into a precision-based medical intervention. Clinicians must leverage both traditional physiological principles and modern digital engagement tools to achieve optimal long-term management of COPD.',
    ),
  ],
);

const _tags = ['COPD', 'Rehabilitation', 'DigitalHealth', 'ClinicalTrials'];

const _relatedArticles = [
  RelatedArticleModel(
    image: 'take_quiz.png',
    category: 'PHARMACOLOGY',
    categoryColor: AppColors.purpleAccent,
    title: 'Novel Bronchodilators: A 2024 Review',
  ),
  RelatedArticleModel(
    image: 'respiratory.png',
    category: 'RESEARCH',
    categoryColor: AppColors.primary,
    title: 'The Microbiome-Lung Axis: Current Understanding',
  ),
];

class ArticleReaderView extends StatelessWidget {
  const ArticleReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const RespiLinkAppBar(showSearchAction: true),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ArticleBookmarkFab(
            onTap: () {
              // TODO: wire to the native bookmark functionality once it exists.
            },
          ),
          3.h.addHeight,
          ArticleShareFab(
            onTap: () {
              // TODO: wire to the native share sheet once it exists.
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleHeaderImage(image: _article.bannerImage),

              SizedBox(height: 16.h),

              ArticleTagRow(tag: _article.tag, readTime: _article.readTime),

              SizedBox(height: 10.h),

              ArticleTitle(title: _article.title),

              SizedBox(height: 14.h),

              ArticleAuthorRow(
                authorName: _article.authorName,
                authorAvatarUrl: _article.authorAvatarUrl,
                publishedLabel: _article.publishedLabel,
              ),

              SizedBox(height: 20.h),

              ArticleBody(
                blocks: _article.blocks,
                onInteractiveWidgetLaunch: (block) {
                  // TODO: launch the interactive lung capacity model once it exists.
                },
              ),

              const ArticleTagsRow(tags: _tags),

              SizedBox(height: 16.h),

              ArticleEngagementBar(
                likeCount: '2.4k',
                commentCount: '142',
                onLikeTap: () {
                  // TODO: wire to the like API once it exists.
                },
                onCommentTap: () {
                  // TODO: navigate to comments once they exist.
                },
                onSaveTap: () {
                  // TODO: wire to the collections API once it exists.
                },
              ),

              SizedBox(height: 24.h),

              RelatedArticlesSection(
                articles: _relatedArticles,
                onArticleTap: (article) {
                  // TODO: navigate to the tapped article once article routing is dynamic.
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

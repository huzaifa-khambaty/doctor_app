import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_details_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/related_article_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/content_details_bloc.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/content_details_event.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/content_details_state.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_author_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_bookmark_fab.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_engagement_bar.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_external_links.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_header_image.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_share_fab.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_tag_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_tags_row.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_title.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/article_video_preview.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_skeletons.dart';
import 'package:respilink_mobile/shared/widgets/app_html_text.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

class ArticleReaderView extends StatelessWidget {
  final int contentId;

  const ArticleReaderView({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    // Page-scoped (not global) so tapping into a related article and
    // navigating back doesn't clobber the previous article's state.
    return BlocProvider<ContentDetailsBloc>(
      create: (context) => ContentDetailsBloc(locator())
        ..add(ContentDetailsRequested(contentId: contentId)),
      child: _ArticleReaderBody(contentId: contentId),
    );
  }
}

class _ArticleReaderBody extends StatelessWidget {
  final int contentId;

  const _ArticleReaderBody({required this.contentId});

  RelatedArticleModel _mapRelated(RelatedContent related) {
    return RelatedArticleModel(
      id: related.id ?? 0,
      image: related.thumbnailUrl ?? related.thumbnailPath ?? '',
      category: related.type?.name?.toUpperCase() ?? '',
      categoryColor: AppColors.primary,
      title: related.title ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const RespiLinkAppBar(showSearchAction: false),
      // Rendered as a Positioned overlay in the body (not via
      // Scaffold.floatingActionButton) so it never participates in the
      // Scaffold's floating-SnackBar avoidance layout, which otherwise
      // throws "Floating SnackBar presented off screen" when the reserved
      // headroom above the FAB column collapses below the SnackBar's height.
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            BlocConsumer<ContentDetailsBloc, ContentDetailsState>(
              listener: (context, state) {
                if (state is ContentDetailsFailed) {
                  SnackbarUtil.showSnackbar(
                    message: state.message,
                    isError: true,
                  );
                }
              },
              builder: (context, state) {
                if (state is ContentDetailsFailed) {
                  return RequestFailed(message: state.message);
                }

                if (state is! ContentDetailsLoaded) {
                  return const ArticleReaderSkeleton();
                }

                final details = state.details;
                final relatedArticles = [
                  for (final related in details.relatedContent ?? const <RelatedContent>[])
                    _mapRelated(related),
                ];

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArticleHeaderImage(image: details.thumbnail ?? ''),

                      SizedBox(height: 16.h),

                      ArticleTagRow(
                        tag: (details.topic ?? details.type ?? '').toUpperCase(),
                        readTime: details.readTime ?? '',
                      ),

                      SizedBox(height: 10.h),

                      ArticleTitle(title: details.title ?? ''),

                      SizedBox(height: 14.h),

                      ArticleAuthorRow(
                        authorName: details.author?.name ?? 'RespiLink',
                        publishedLabel: details.publishedAt ?? '',
                      ),

                      SizedBox(height: 20.h),

                      AppHtmlText(html: details.body ?? ''),

                      if ((details.webinarUrl ?? '').trim().isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        ArticleVideoPreview(
                          videoUrl: details.webinarUrl,
                          thumbnailUrl: details.thumbnail,
                        ),
                      ],

                      if ((details.externalUrl ?? '').trim().isNotEmpty ||
                          (details.externalLinks ?? const []).isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        ArticleExternalLinks(
                          externalUrl: details.externalUrl,
                          externalLinks: details.externalLinks,
                        ),
                      ],

                      SizedBox(height: 16.h),

                      ArticleTagsRow(tags: details.tags ?? const []),

                      SizedBox(height: 16.h),

                      ArticleEngagementBar(
                        likeCount: '${details.likes ?? 0}',
                        commentCount: '${details.commentsCount ?? 0}',
                        isLiked: details.isLiked ?? false,
                        onLikeTap: () => context.read<ContentDetailsBloc>().add(
                          ContentLikeToggled(),
                        ),
                        onCommentTap: () {
                          // TODO: navigate to comments once they exist.
                        },
                        onSaveTap: () => context.read<ContentDetailsBloc>().add(
                          ContentBookmarkToggled(),
                        ),
                      ),

                      // if (relatedArticles.isNotEmpty) ...[
                      //   SizedBox(height: 24.h),
                      //   RelatedArticlesSection(
                      //     articles: relatedArticles,
                      //     onArticleTap: (article) {
                      //       locator<NavigationService>().navigate(
                      //         RouterStrings.articleReaderView,
                      //         arguments: article.id,
                      //       );
                      //     },
                      //   ),
                      // ],

                      // SizedBox(height: 16.h),

                      // Reserve room so the FAB overlay never covers the
                      // last piece of content.
                      SizedBox(height: 72.h),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 16.w,
              bottom: 16.h,
              child: BlocBuilder<ContentDetailsBloc, ContentDetailsState>(
                builder: (context, state) {
                  final isBookmarked = state is ContentDetailsLoaded
                      ? (state.details.isSaved ?? false)
                      : false;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ArticleBookmarkFab(
                        isBookmarked: isBookmarked,
                        onTap: () => context.read<ContentDetailsBloc>().add(
                          ContentBookmarkToggled(),
                        ),
                      ),
                      3.h.addHeight,
                      ArticleShareFab(
                        onTap: () {
                          // TODO: wire to the native share sheet once it exists.
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

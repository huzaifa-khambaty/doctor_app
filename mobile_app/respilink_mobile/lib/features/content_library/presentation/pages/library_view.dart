import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/content_library/data/services/content_download_service.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';
import 'package:respilink_mobile/features/content_library/domain/repositories/content_library_repository.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_bloc.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_event.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_state.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/assessment_library_card.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/document_library_card.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_filter_chips.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_header_banner.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/library_skeletons.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/media_library_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_state.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;
  int? _startingQuizId;
  int? _loadingContentId;

  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(LibraryRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= maxScroll - 200.h) {
      context.read<LibraryBloc>().add(LibraryLoadMoreRequested());
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<LibraryBloc>().add(LibrarySearchChanged(query: query));
    });
  }

  void _startQuiz(int? quizId) {
    if (quizId == null || _startingQuizId != null) return;

    setState(() => _startingQuizId = quizId);
    context.read<QuizAttemptBloc>().add(
      QuizAttemptStartRequested(quizId: quizId),
    );
  }

  /// Article/webinar tap: bump the view count first, then open the reader —
  /// sequential and asynchronous, but a failed count-bump must never block
  /// the user from actually reading the content.
  Future<void> _openContent(LibraryContentModel content) async {
    if (_loadingContentId != null) return;

    setState(() => _loadingContentId = content.id);
    try {
      await locator<ContentLibraryRepository>().increaseCount(content.id);
    } catch (_) {
      // Non-critical analytics ping — ignore failures.
    }

    if (!mounted) return;
    setState(() => _loadingContentId = null);
    locator<NavigationService>().navigate(
      RouterStrings.articleReaderView,
      arguments: content.id,
    );
  }

  Future<void> _openPdf(LibraryContentModel content) async {
    if (_loadingContentId != null || content.pdfUrl == null) return;

    setState(() => _loadingContentId = content.id);
    unawaited(
      locator<ContentLibraryRepository>().increaseDownloadCount(content.id),
    );

    try {
      await locator<ContentDownloadService>().downloadAndOpen(
        content.pdfUrl!,
        'content_${content.id}.pdf',
      );
    } catch (_) {
      if (mounted) {
        SnackbarUtil.showSnackbar(
          message: 'Failed to open the PDF. Please try again.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _loadingContentId = null);
    }
  }

  Widget _cardFor(LibraryContentModel content) {
    return switch (content.type) {
      LibraryContentType.article ||
      LibraryContentType.webinar => MediaLibraryCard(
          content: content,
          isLoading: _loadingContentId == content.id,
          onTap: () => _openContent(content),
          onBookmarkTap: () {
            // TODO: wire to the bookmark/save API once it exists.
          },
        ),
      LibraryContentType.pdf => DocumentLibraryCard(
          content: content,
          isLoading: _loadingContentId == content.id,
          onTap: () => _openPdf(content),
          onBookmarkTap: () {
            // TODO: wire to the bookmark/save API once it exists.
          },
        ),
      LibraryContentType.quiz => AssessmentLibraryCard(
          content: content,
          isLoading: _startingQuizId != null && _startingQuizId == content.quizId,
          onStart: () => _startQuiz(content.quizId),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizAttemptBloc, QuizAttemptState>(
      listener: (context, attemptState) {
        if (attemptState is QuizAttemptStarted) {
          setState(() => _startingQuizId = null);
          locator<NavigationService>().navigate(
            RouterStrings.quizPlay,
            arguments: attemptState.quizId,
          );
        } else if (attemptState is QuizAttemptFailed) {
          setState(() => _startingQuizId = null);
          SnackbarUtil.showSnackbar(
            message: attemptState.message,
            isError: true,
          );
        }
      },
      child: BlocConsumer<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if (state is LibraryFailed) {
            SnackbarUtil.showSnackbar(message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          // The header/search bar and filter chips scroll together with the
          // results below as a single page — only the composition of the
          // results slivers changes (skeleton/empty/error/list).
          final selectedFilter = switch (state) {
            LibraryLoaded(:final filter) => filter,
            LibraryFailed(:final filter) => filter,
            _ => LibraryFilter.topics,
          };

          return SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<LibraryBloc>().add(
                  LibraryRequested(
                    filter: selectedFilter,
                    search: state is LibraryLoaded ? state.search : '',
                  ),
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: LibraryHeaderBanner(
                        title: state is LibraryLoaded
                            ? state.heroTitle
                            : 'Medical Library',
                        subtitle: state is LibraryLoaded
                            ? state.heroSubtitle
                            : 'Access peer-reviewed pulmonary research and clinical guidelines updated daily.',
                        onSearchChanged: _onSearchChanged,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverToBoxAdapter(
                      child: LibraryFilterChips(
                        selected: selectedFilter,
                        onSelected: (filter) => context.read<LibraryBloc>().add(
                          LibraryFilterChanged(filter: filter),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  ..._buildResultSlivers(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildResultSlivers(LibraryState state) {
    if (state is LibraryFailed) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RequestFailed(message: state.message),
        ),
      ];
    }

    if (state is! LibraryLoaded) {
      return [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: const SliverToBoxAdapter(child: LibraryResultsSkeleton()),
        ),
      ];
    }

    if (state.items.isEmpty) {
      return [SliverToBoxAdapter(child: SizedBox(height: 180.h))];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == state.items.length) {
              return state.isLoadingMore
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _cardFor(state.items[index]),
            );
          }, childCount: state.items.length + 1),
        ),
      ),
    ];
  }
}

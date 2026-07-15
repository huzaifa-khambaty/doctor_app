import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_list_model.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

enum _SortMode { newest, oldest, alpha }

class QuizDirectoryContent extends StatefulWidget {
  const QuizDirectoryContent({
    super.key,
    required this.onCreateQuizClicked,
    required this.onEditQuizClicked,
  });

  final VoidCallback onCreateQuizClicked;
  final void Function(int quizId) onEditQuizClicked;

  @override
  State<QuizDirectoryContent> createState() => _QuizDirectoryContentState();
}

class _QuizDirectoryContentState extends State<QuizDirectoryContent> {
  String _searchQuery = '';
  _SortMode _sortMode = _SortMode.newest;
  int? _topicFilterId;
  Timer? _debounce;

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _searchQuery = value.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizBloc, QuizState>(
      listenWhen: (prev, curr) =>
          (prev.actionSuccess != curr.actionSuccess && curr.actionSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.actionSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Action completed.');
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(
            context,
            message: state.error!,
            isError: true,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuizSearchBarHeader(onSearch: _onSearch),
              const SizedBox(height: 24),
              _QuizTitleActionRow(onCreateQuizClicked: widget.onCreateQuizClicked),
              const SizedBox(height: 24),
              const _QuizMetricsGridSection(),
              const SizedBox(height: 28),
              _QuizUtilityControlRow(
                sortMode: _sortMode,
                topicFilterId: _topicFilterId,
                onSortChanged: (m) => setState(() => _sortMode = m),
                onTopicFilterChanged: (id) => setState(() => _topicFilterId = id),
              ),
              const SizedBox(height: 16),
              _QuizDirectoryListBlock(
                onEditQuizClicked: widget.onEditQuizClicked,
                searchQuery: _searchQuery,
                sortMode: _sortMode,
                topicFilterId: _topicFilterId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header / title
// ─────────────────────────────────────────────────────────────────────────────

class _QuizSearchBarHeader extends StatelessWidget {
  const _QuizSearchBarHeader({required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search quizzes or topics...',
                hintStyle:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.textDark,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.help_outline_rounded,
            color: AppColors.textMuted,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _QuizTitleActionRow extends StatelessWidget {
  const _QuizTitleActionRow({required this.onCreateQuizClicked});
  final VoidCallback onCreateQuizClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Management',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted.withValues(alpha: 0.8),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    '›',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                ),
                const Text(
                  'Quizzes',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Quiz Directory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage educational modules and clinician assessments.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onCreateQuizClicked,
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: const Text(
            'Create New Quiz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizUtilityControlRow extends StatelessWidget {
  const _QuizUtilityControlRow({
    required this.sortMode,
    required this.topicFilterId,
    required this.onSortChanged,
    required this.onTopicFilterChanged,
  });

  final _SortMode sortMode;
  final int? topicFilterId;
  final ValueChanged<_SortMode> onSortChanged;
  final ValueChanged<int?> onTopicFilterChanged;

  String get _sortLabel => switch (sortMode) {
        _SortMode.newest => 'Sort: Newest',
        _SortMode.oldest => 'Sort: Oldest',
        _SortMode.alpha => 'Sort: A–Z',
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      buildWhen: (p, c) =>
          p.totalQuizzes != c.totalQuizzes || p.topics != c.topics,
      builder: (context, state) {
        final hasFilter = topicFilterId != null;
        final topicName = hasFilter
            ? state.topics
                .where((t) => t.id == topicFilterId)
                .map((t) => t.name)
                .firstOrNull
            : null;
        final filterLabel =
            hasFilter ? 'Topic: ${topicName ?? '…'}' : 'Filter';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Topic filter
                PopupMenuButton<int>(
                  onSelected: (id) =>
                      onTopicFilterChanged(id == -1 ? null : id),
                  itemBuilder: (_) => [
                    const PopupMenuItem<int>(
                        value: -1, child: Text('All Topics')),
                    ...state.topics.map((t) => PopupMenuItem<int>(
                          value: t.id ?? -1,
                          child: Text(t.name ?? ''),
                        )),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: hasFilter
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.white,
                      border: Border.all(
                        color: hasFilter
                            ? AppColors.primary
                            : AppColors.borderLight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list_rounded,
                            size: 14,
                            color: hasFilter
                                ? AppColors.primary
                                : AppColors.textDark),
                        const SizedBox(width: 6),
                        Text(
                          filterLabel,
                          style: TextStyle(
                            color: hasFilter
                                ? AppColors.primary
                                : AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hasFilter) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => onTopicFilterChanged(null),
                            child: const Icon(Icons.close,
                                size: 12, color: AppColors.primary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Sort
                PopupMenuButton<_SortMode>(
                  onSelected: onSortChanged,
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: _SortMode.newest,
                        child: Text('Newest First')),
                    PopupMenuItem(
                        value: _SortMode.oldest,
                        child: Text('Oldest First')),
                    PopupMenuItem(
                        value: _SortMode.alpha, child: Text('A–Z')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort_rounded,
                            size: 14, color: AppColors.textDark),
                        const SizedBox(width: 6),
                        Text(
                          _sortLabel,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              state.totalQuizzes == 0
                  ? 'No quizzes found'
                  : 'Total ${state.totalQuizzes} quiz${state.totalQuizzes == 1 ? '' : 'zes'}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats grid — driven by real totals from state
// ─────────────────────────────────────────────────────────────────────────────

class _QuizMetricsGridSection extends StatelessWidget {
  const _QuizMetricsGridSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      buildWhen: (p, c) =>
          p.quizzes != c.quizzes || p.totalQuizzes != c.totalQuizzes,
      builder: (context, state) {
        final total = state.totalQuizzes;
        final active = state.quizzes
            .where((q) => q.status?.toLowerCase() == 'live' ||
                q.status?.toLowerCase() == 'published')
            .length;
        final participants = state.quizzes.fold<int>(
            0, (sum, q) => sum + (q.participantsCount ?? 0));

        return LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = (constraints.maxWidth - (3 * 16)) / 4;
            if (cardWidth < 165) cardWidth = 165;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _QuizStatCard(
                  width: cardWidth,
                  title: 'Total Quizzes',
                  value: '$total',
                  icon: Icons.grid_view_rounded,
                  iconColor: Colors.teal,
                ),
                _QuizStatCard(
                  width: cardWidth,
                  title: 'Active Quizzes',
                  value: '$active',
                  icon: Icons.bolt,
                  iconColor: Colors.blueAccent,
                ),
                _QuizStatCard(
                  width: cardWidth,
                  title: 'Total Participants',
                  value: '$participants',
                  icon: Icons.people_outline_rounded,
                  iconColor: Colors.orangeAccent,
                ),
                _QuizStatCard(
                  width: cardWidth,
                  title: 'Completion Rate',
                  value: '—',
                  icon: Icons.assignment_turned_in_outlined,
                  iconColor: Colors.purpleAccent,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _QuizStatCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _QuizStatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main quiz table
// ─────────────────────────────────────────────────────────────────────────────

class _QuizDirectoryListBlock extends StatelessWidget {
  const _QuizDirectoryListBlock({
    required this.onEditQuizClicked,
    required this.searchQuery,
    required this.sortMode,
    required this.topicFilterId,
  });

  final void Function(int quizId) onEditQuizClicked;
  final String searchQuery;
  final _SortMode sortMode;
  final int? topicFilterId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        var quizzes = state.quizzes;
        if (!state.isLoadingQuizzes) {
          if (searchQuery.isNotEmpty) {
            quizzes = quizzes.where((q) {
              return (q.title ?? '').toLowerCase().contains(searchQuery) ||
                  (q.topic?.name ?? '').toLowerCase().contains(searchQuery);
            }).toList();
          }
          if (topicFilterId != null) {
            quizzes = quizzes
                .where((q) => q.topicId == topicFilterId)
                .toList();
          }
          quizzes = switch (sortMode) {
            _SortMode.newest => (List.of(quizzes)
              ..sort((a, b) =>
                  (b.createdAt ?? '').compareTo(a.createdAt ?? ''))),
            _SortMode.oldest => (List.of(quizzes)
              ..sort((a, b) =>
                  (a.createdAt ?? '').compareTo(b.createdAt ?? ''))),
            _SortMode.alpha => (List.of(quizzes)
              ..sort(
                  (a, b) => (a.title ?? '').compareTo(b.title ?? ''))),
          };
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.6),
                  1: FlexColumnWidth(1.0),
                  2: FlexColumnWidth(1.1),
                  3: FlexColumnWidth(1.1),
                  4: FlexColumnWidth(1.3),
                  5: FlexColumnWidth(1.5),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _headerRow(),
                  if (state.isLoadingQuizzes)
                    ..._shimmerRows()
                  else if (quizzes.isEmpty)
                    _emptyRow()
                  else
                    ...quizzes.map(
                      (q) => _dataRow(
                        context,
                        q,
                        state.actioningQuizId == q.id,
                        onEditQuizClicked,
                      ),
                    ),
                ],
              ),
              _TablePaginationFooter(
                currentPage: state.currentPage,
                lastPage: state.lastPage,
              ),
            ],
          ),
        );
      },
    );
  }

  TableRow _headerRow() {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: AppColors.textMuted,
    );
    const deco = BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.borderLight)),
    );
    return TableRow(
      decoration: deco,
      children: const [
        Padding(padding: EdgeInsets.all(14), child: Text('Quiz Title', style: style)),
        Padding(padding: EdgeInsets.all(14), child: Text('Topic', style: style)),
        Padding(padding: EdgeInsets.all(14), child: Text('Questions', style: style)),
        Padding(padding: EdgeInsets.all(14), child: Text('Status', style: style)),
        Padding(padding: EdgeInsets.all(14), child: Text('Participants', style: style)),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text('Actions', style: style, textAlign: TextAlign.right),
        ),
      ],
    );
  }

  List<TableRow> _shimmerRows() {
    return List.generate(
      5,
      (_) => TableRow(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        children: List.generate(
          6,
          (ci) => Padding(
            padding: const EdgeInsets.all(14),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE2E8F0),
              highlightColor: const Color(0xFFF8FAFC),
              child: Container(
                height: 14,
                width: ci == 0 ? 160 : 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _emptyRow() {
    return TableRow(children: [
      TableCell(
        child: Container(),
      ),
      TableCell(child: Container()),
      TableCell(child: Container()),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No quizzes found',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ),
      TableCell(child: Container()),
      TableCell(child: Container()),
    ]);
  }

  TableRow _dataRow(
    BuildContext context,
    Data quiz,
    bool isActioning,
    void Function(int quizId) onEditQuizClicked,
  ) {
    final status = quiz.status ?? 'draft';
    final statusLower = status.toLowerCase();
    final isLive =
        statusLower == 'live' || statusLower == 'published';
    final isCompleted = statusLower == 'completed' || statusLower == 'closed';

    final statusColor = isLive
        ? Colors.teal
        : isCompleted
            ? Colors.blue
            : Colors.grey;

    final statusLabel = isLive
        ? 'Live'
        : isCompleted
            ? 'Completed'
            : 'Draft';

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.quiz_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quiz.createdAt != null
                          ? 'Created ${_formatDate(quiz.createdAt!)}'
                          : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Topic
        Padding(
          padding: const EdgeInsets.all(14),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                quiz.topic?.name ?? '—',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Questions count
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            '${quiz.questionsCount ?? 0} Questions',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Status
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, color: statusColor, size: 8),
              const SizedBox(width: 6),
              Text(
                statusLabel,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Participants
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            '${quiz.participantsCount ?? 0}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Actions
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                splashRadius: 16,
                tooltip: 'Edit',
                onPressed: quiz.id != null ? () => onEditQuizClicked(quiz.id!) : null,
              ),
              if (isLive)
                IconButton(
                  icon: const Icon(
                    Icons.bar_chart_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  splashRadius: 16,
                  tooltip: 'Analytics',
                  onPressed: () {},
                ),
              if (isActioning)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                PopupMenuButton<_QuizAction>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  onSelected: (action) =>
                      _handleAction(context, action, quiz, onEditQuizClicked),
                  itemBuilder: (_) => [
                    if (!isLive && !isCompleted)
                      _menuItem(
                        _QuizAction.publish,
                        Icons.publish_rounded,
                        'Publish',
                        Colors.teal,
                      ),
                    if (isLive)
                      _menuItem(
                        _QuizAction.unpublish,
                        Icons.unpublished_outlined,
                        'Unpublish',
                        Colors.orange,
                      ),
                    // _menuItem(
                    //   _QuizAction.edit,
                    //   Icons.edit_outlined,
                    //   'Edit',
                    //   Colors.blueAccent,
                    // ),
                    _menuItem(
                      _QuizAction.delete,
                      Icons.delete_outline,
                      'Delete',
                      Colors.red,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem<_QuizAction> _menuItem(
    _QuizAction action,
    IconData icon,
    String label,
    Color color,
  ) {
    return PopupMenuItem<_QuizAction>(
      value: action,
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    _QuizAction action,
    Data quiz,
    void Function(int quizId) onEditQuizClicked,
  ) {
    if (quiz.id == null) return;
    switch (action) {
      case _QuizAction.publish:
        context.read<QuizBloc>().add(
              ToggleQuizStatusRequested(quizId: quiz.id!, publish: true),
            );
        break;
      case _QuizAction.unpublish:
        context.read<QuizBloc>().add(
              ToggleQuizStatusRequested(quizId: quiz.id!, publish: false),
            );
        break;
      case _QuizAction.edit:
        onEditQuizClicked(quiz.id!);
        break;
      case _QuizAction.delete:
        _confirmDelete(context, quiz);
        break;
    }
  }

  void _confirmDelete(BuildContext context, Data quiz) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Quiz',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${quiz.title}"? This action cannot be undone.',
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<QuizBloc>()
                  .add(DeleteQuizRequested(quiz.id!));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) {
        final m = diff.inMinutes;
        return '$m min${m == 1 ? '' : 's'} ago';
      }
      if (diff.inHours < 24) {
        final h = diff.inHours;
        return '$h hour${h == 1 ? '' : 's'} ago';
      }
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays} days ago';

      final fmt = dt.year == now.year
          ? DateFormat('MMM d')
          : DateFormat('MMM d, yyyy');
      return fmt.format(dt);
    } catch (_) {
      return raw;
    }
  }
}

enum _QuizAction { publish, unpublish, edit, delete }

// ─────────────────────────────────────────────────────────────────────────────
// Pagination footer
// ─────────────────────────────────────────────────────────────────────────────

class _TablePaginationFooter extends StatelessWidget {
  final int currentPage;
  final int lastPage;

  const _TablePaginationFooter({
    required this.currentPage,
    required this.lastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page $currentPage of $lastPage',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left, size: 16),
                onPressed: currentPage <= 1
                    ? null
                    : () => context.read<QuizBloc>().add(
                          FetchQuizzesRequested(page: currentPage - 1),
                        ),
              ),
              ...List.generate(lastPage, (i) {
                final page = i + 1;
                final active = page == currentPage;
                return GestureDetector(
                  onTap: active
                      ? null
                      : () => context.read<QuizBloc>().add(
                            FetchQuizzesRequested(page: page),
                          ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.sidebarBg
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$page',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 16),
                onPressed: currentPage >= lastPage
                    ? null
                    : () => context.read<QuizBloc>().add(
                          FetchQuizzesRequested(page: currentPage + 1),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

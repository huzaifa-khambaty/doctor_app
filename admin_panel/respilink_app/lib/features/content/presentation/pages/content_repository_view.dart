import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_bloc.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_event.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_state.dart';
import 'package:respilink_app/shared/widgets/app_popup_menu_button.dart';
import 'package:shimmer/shimmer.dart';

class ContentRepositoryContent extends StatefulWidget {
  final VoidCallback? onAddContentClicked;
  final void Function(Data)? onEditContentClicked;

  const ContentRepositoryContent({
    super.key,
    this.onAddContentClicked,
    this.onEditContentClicked,
  });

  @override
  State<ContentRepositoryContent> createState() => _ContentRepositoryContentState();
}

class _ContentRepositoryContentState extends State<ContentRepositoryContent> {
  String? _activeStatus;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch();
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetch({int page = 1}) {
    final search = _searchCtrl.text.trim();
    context.read<ContentBloc>().add(FetchContentsRequested(
      page: page,
      status: _activeStatus,
      search: search.isEmpty ? null : search,
    ));
  }

  void _onSearchChanged() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _fetch);
  }

  void _onFilterChanged(String? status) {
    setState(() => _activeStatus = status);
    _fetch();
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Content'),
        content: const Text('Are you sure you want to delete this content? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ContentBloc>().add(DeleteContentRequested(id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _togglePublish(Data item) {
    if (item.id == null) return;
    final newStatus = item.status == 'published' ? 'draft' : 'published';
    context.read<ContentBloc>().add(UpdateContentStatusRequested(item.id!, newStatus));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContentBloc, ContentState>(
      listenWhen: (prev, curr) =>
          (!prev.submitSuccess && curr.submitSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
        if (state.submitSuccess) {
          _fetch(page: state.contentData?.contents?.currentPage ?? 1);
        }
      },
      builder: (context, state) {
        final items = state.contentData?.contents?.data ?? [];
        final contents = state.contentData?.contents;
        return Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildTitleSection(),
                const SizedBox(height: 24),
                _buildMetricsGrid(state),
                const SizedBox(height: 24),
                _buildTable(state, items, contents),
                const SizedBox(height: 24),
                _buildBottomSection(state),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search content...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                        onPressed: () {
                          _searchCtrl.clear();
                          _fetch();
                        },
                      )
                    : null,
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
          icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textDark),
          onPressed: () {},
        ),
      ],
    );
  }

  // ── Title Section ──────────────────────────────────────────────────────────

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Repository',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            SizedBox(height: 4),
            Text(
              'Manage clinical studies, educational modules, and scientific events.',
              style: TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
        Row(
          children: [
            if (widget.onAddContentClicked != null) ...[
              ElevatedButton.icon(
                onPressed: widget.onAddContentClicked,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  'Add Content',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B5C),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  _FilterChip(label: 'All', isActive: _activeStatus == null, onTap: () => _onFilterChanged(null)),
                  _FilterChip(label: 'Drafts', isActive: _activeStatus == 'draft', onTap: () => _onFilterChanged('draft')),
                  _FilterChip(label: 'Published', isActive: _activeStatus == 'published', onTap: () => _onFilterChanged('published')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Metrics Grid ───────────────────────────────────────────────────────────

  Widget _buildMetricsGrid(ContentState state) {
    final stats = state.contentData?.stats;
    final shimmer = state.isLoadingContents && state.contentData == null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = ((constraints.maxWidth - 48) / 4).clamp(160.0, double.infinity);
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _MetricCard(width: cardWidth, title: 'Total Content', value: stats?.total?.toString() ?? '0', icon: Icons.description_outlined, color: Colors.blueAccent, shimmer: shimmer),
            _MetricCard(width: cardWidth, title: 'Webinars', value: stats?.webinars?.toString() ?? '0', icon: Icons.video_library_outlined, color: Colors.purpleAccent, shimmer: shimmer),
            _MetricCard(width: cardWidth, title: 'Live Quizzes', value: stats?.liveQuizzes?.toString() ?? '0', icon: Icons.quiz_outlined, color: Colors.orangeAccent, shimmer: shimmer),
            _MetricCard(width: cardWidth, title: 'Upcoming Events', value: stats?.upcomingEvents?.toString() ?? '0', icon: Icons.calendar_today_outlined, color: Colors.redAccent, shimmer: shimmer),
          ],
        );
      },
    );
  }

  // ── Table ──────────────────────────────────────────────────────────────────

  Widget _buildTable(ContentState state, List<Data> items, Contents? contents) {
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
              0: FlexColumnWidth(3.0),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(0.8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _headerRow(),
              if (state.isLoadingContents)
                ..._skeletonRows()
              else
                ...items.map((item) => _dataRow(item, state.actioningContentId == item.id)),
            ],
          ),
          if (items.isEmpty && !state.isLoadingContents)
            Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.description_outlined, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text(
                      'No content found',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          if (contents != null && (contents.total ?? 0) > 0)
            _Pagination(
              currentPage: contents.currentPage ?? 1,
              lastPage: contents.lastPage ?? 1,
              total: contents.total ?? 0,
              from: contents.from ?? 0,
              to: contents.to ?? 0,
              onPageChanged: (p) => _fetch(page: p),
            ),
        ],
      ),
    );
  }

  TableRow _headerRow() {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted);
    return const TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(padding: EdgeInsets.all(16), child: Text('TITLE', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('TYPE', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('TOPIC', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('DATE CREATED', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('STATUS', style: style)),
        Padding(padding: EdgeInsets.all(16), child: SizedBox()),
      ],
    );
  }

  List<TableRow> _skeletonRows() {
    return List.generate(
      6,
      (_) => TableRow(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Shimmer(child: Container(height: 12, width: 160, decoration: _shBox)),
                const SizedBox(height: 6),
                _Shimmer(child: Container(height: 10, width: 90, decoration: _shBox)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(
              child: Container(
                height: 22,
                width: 56,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(child: Container(height: 12, width: 100, decoration: _shBox)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(child: Container(height: 12, width: 80, decoration: _shBox)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(child: Container(height: 12, width: 70, decoration: _shBox)),
          ),
          const Padding(padding: EdgeInsets.all(16), child: SizedBox()),
        ],
      ),
    );
  }

  TableRow _dataRow(Data item, bool isActioning) {
    final typeId = item.type?.id ?? item.typeId;
    final typeLabel = item.type?.name ?? _typeLabel(typeId);
    final typeColor = _typeColor(typeId);
    final specialty = item.specialties?.isNotEmpty == true ? (item.specialties!.first.name ?? '') : '—';
    final dateStr = _fmtDate(item.createdAt);
    final statusColor = _statusColor(item.status);
    final isPublished = item.status == 'published';

    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(
                '${item.viewsCount ?? 0} views • ${item.likesCount ?? 0} likes',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: typeColor.withValues(alpha: 0.2)),
              ),
              child: Text(typeLabel, style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(specialty, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(dateStr, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, color: statusColor, size: 8),
              const SizedBox(width: 6),
              Text(_statusLabel(item.status), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: isActioning
              ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              : AppPopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        widget.onEditContentClicked?.call(item);
                      case 'toggle_publish':
                        _togglePublish(item);
                      case 'delete':
                        if (item.id != null) _confirmDelete(item.id!);
                    }
                  },
                  items: [
                    AppPopupMenuItem(
                      value: 'edit',
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: AppColors.sidebarBg,
                    ),
                    AppPopupMenuItem(
                      value: 'toggle_publish',
                      icon: isPublished ? Icons.visibility_off_outlined : Icons.publish_outlined,
                      label: isPublished ? 'Unpublish' : 'Publish',
                      color: AppColors.sidebarBg,
                      hasDividerAfter: true,
                    ),
                    const AppPopupMenuItem(
                      value: 'delete',
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: Colors.red,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // ── Bottom Section ─────────────────────────────────────────────────────────

  Widget _buildBottomSection(ContentState state) {
    final isNarrow = MediaQuery.of(context).size.width < 1000;
    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SystemLogsSection(),
          const SizedBox(height: 24),
          _ContentMixSection(state: state),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: const _SystemLogsSection()),
        const SizedBox(width: 24),
        Expanded(child: _ContentMixSection(state: state)),
      ],
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Color _typeColor(int? typeId) {
    switch (typeId) {
      case 1: return Colors.red;
      case 2: return Colors.teal;
      case 3: return Colors.blue;
      case 4: return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _typeLabel(int? typeId) {
    switch (typeId) {
      case 1: return 'PDF';
      case 2: return 'Article';
      case 3: return 'Webinar';
      case 4: return 'Quiz';
      default: return 'Unknown';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'published': return AppColors.successGreen;
      case 'review': return AppColors.warningOrange;
      default: return AppColors.textMuted;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'published': return 'Published';
      case 'review': return 'In Review';
      default: return 'Draft';
    }
  }

  String _fmtDate(String? raw) {
    if (raw == null) return '—';
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(raw).toLocal());
    } catch (_) {
      return raw;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer helpers
// ─────────────────────────────────────────────────────────────────────────────

final _shBox = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6));

class _Shimmer extends StatelessWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter chip
// ─────────────────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.scaffoldBg : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.textDark : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric card
// ─────────────────────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool shimmer;

  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.shimmer = false,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              shimmer
                  ? Container(width: 40, height: 20, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)))
                  : Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pagination
// ─────────────────────────────────────────────────────────────────────────────

class _Pagination extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final int total;
  final int from;
  final int to;
  final void Function(int) onPageChanged;

  const _Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.from,
    required this.to,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $from–$to of $total items',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          Row(
            children: [
              _NavBtn(
                icon: Icons.keyboard_arrow_left,
                enabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 6),
              ..._pageNums(),
              const SizedBox(width: 6),
              _NavBtn(
                icon: Icons.keyboard_arrow_right,
                enabled: currentPage < lastPage,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _pageNums() {
    final nums = <int>{1, lastPage};
    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (i >= 1 && i <= lastPage) nums.add(i);
    }
    final sorted = nums.toList()..sort();
    final widgets = <Widget>[];
    int? prev;
    for (final p in sorted) {
      if (prev != null && p - prev > 1) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('...', style: TextStyle(color: AppColors.textMuted)),
        ));
      }
      widgets.add(_PageNumBtn(page: p, isActive: p == currentPage, onTap: () => onPageChanged(p)));
      prev = p;
    }
    return widgets;
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavBtn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderLight),
        padding: const EdgeInsets.all(8),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Icon(icon, size: 16, color: enabled ? AppColors.textDark : AppColors.textMuted),
    );
  }
}

class _PageNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumBtn({required this.page, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.sidebarBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textDark,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom: System Logs (static) + Content Mix (real data)
// ─────────────────────────────────────────────────────────────────────────────

class _SystemLogsSection extends StatelessWidget {
  const _SystemLogsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history_toggle_off, size: 18, color: AppColors.textDark),
              SizedBox(width: 8),
              Text('Recent System Logs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 20),
          _logItem('New Quiz Published', '"Pharmacological Interventions in Asthma" was moved to published.', '14 MINUTES AGO', AppColors.primary),
          const Divider(color: AppColors.borderLight, height: 24),
          _logItem('PDF Upload Failed', '"Invasive Ventilation Protocol.pdf" failed validation due to file size limits.', '2 HOURS AGO', AppColors.errorRed),
          const Divider(color: AppColors.borderLight, height: 24),
          _logItem('Event Registration Peak', '"Pulmonology Summit 2024" reached 85% capacity in the Geneva venue.', '4 HOURS AGO', AppColors.warningOrange),
        ],
      ),
    );
  }

  Widget _logItem(String title, String detail, String time, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 4), child: Icon(Icons.fiber_manual_record, color: color, size: 8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(detail, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentMixSection extends StatelessWidget {
  final ContentState state;
  const _ContentMixSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = state.contentData?.stats;
    final total = stats?.total ?? 0;
    final webinars = stats?.webinars ?? 0;
    final quizzes = stats?.liveQuizzes ?? 0;
    final others = (total - webinars - quizzes).clamp(0, total);

    double r(int v) => total > 0 ? v / total : 0;
    String pct(int v) => '${(r(v) * 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Content Mix', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 24),
          _MixRow(title: 'Clinical Webinars', percent: pct(webinars), color: Colors.blue, value: r(webinars)),
          const SizedBox(height: 16),
          _MixRow(title: 'Live Quizzes', percent: pct(quizzes), color: Colors.orange, value: r(quizzes)),
          const SizedBox(height: 16),
          _MixRow(title: 'Articles & PDFs', percent: pct(others), color: Colors.teal, value: r(others)),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderLight),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View Full Audit Report', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MixRow extends StatelessWidget {
  final String title;
  final String percent;
  final Color color;
  final double value;

  const _MixRow({required this.title, required this.percent, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            Text(percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.scaffoldBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

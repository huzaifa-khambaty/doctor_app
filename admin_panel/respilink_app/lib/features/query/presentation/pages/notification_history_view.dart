import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/query/data/model/all_notifications_model.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_bloc.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_event.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_state.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/shared/widgets/app_skeleton.dart';

// ─── Audience segment options ────────────────────────────────────────────────
const _audienceOptions = {
  'all_users': 'All Users',
  'verified_clinicians': 'Verified Clinicians',
  'specialty_pulmonology': 'Specialty: Pulmonology',
  'specialty_cardiology': 'Specialty: Cardiology',
};

// Reverse-lookup display label → dropdown key
String? _labelToKey(String? label) {
  if (label == null) return null;
  try {
    return _audienceOptions.entries.firstWhere((e) => e.value == label).key;
  } catch (_) {
    return null;
  }
}

// ─── Date helpers ─────────────────────────────────────────────────────────────
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String _formatDate(String? iso) {
  if (iso == null) return '—';
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return '—';
  return '${_months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _formatScheduled(String? iso) {
  if (iso == null) return '—';
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return '—';
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  final min = dt.minute.toString().padLeft(2, '0');
  return '${_months[dt.month - 1]} ${dt.day}, $h:$min $ampm';
}

// ─── Edit pre-fill data ────────────────────────────────────────────────────────
class _NotificationEditData {
  final int id;
  final String? title;
  final String? audienceLabel;
  final String? scheduledAt;

  const _NotificationEditData({
    required this.id,
    this.title,
    this.audienceLabel,
    this.scheduledAt,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class NotificationHistoryView extends StatefulWidget {
  final VoidCallback onBackToUsers;

  const NotificationHistoryView({super.key, required this.onBackToUsers});

  @override
  State<NotificationHistoryView> createState() => _NotificationHistoryViewState();
}

class _NotificationHistoryViewState extends State<NotificationHistoryView> {
  late final NotificationBloc _bloc;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _bloc = locator<NotificationBloc>();
    _bloc.add(FetchNotificationsRequested(page: _page));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() => _page = page);
    _bloc.add(FetchNotificationsRequested(page: page));
  }

  Future<void> _showCreateDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _NotificationFormDialog(),
    );
    _bloc.add(FetchNotificationsRequested(page: _page));
  }

  Future<void> _onEdit(_NotificationEditData editData) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _NotificationFormDialog(editData: editData),
    );
    _bloc.add(FetchNotificationsRequested(page: _page));
  }

  Future<void> _onDelete(int id) async {
    final confirm = await _confirmDialog(
      title: 'Delete Notification',
      content: 'This notification will be permanently deleted and cannot be recovered.',
      confirmLabel: 'Delete',
    );
    if (confirm == true && mounted) {
      _bloc.add(DeleteNotificationRequested(id: id));
    }
  }

  Future<void> _onCancel(int id) async {
    final confirm = await _confirmDialog(
      title: 'Cancel Scheduled Notification',
      content: 'The notification will be cancelled and will not be sent at the scheduled time.',
      confirmLabel: 'Cancel Notification',
    );
    if (confirm == true && mounted) {
      _bloc.add(CancelNotificationRequested(id: id));
    }
  }

  Future<bool?> _confirmDialog({
    required String title,
    required String content,
    required String confirmLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        content: Text(content, style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(confirmLabel, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      bloc: _bloc,
      listenWhen: (prev, curr) =>
          (prev.error != curr.error && curr.error != null) ||
          (prev.actionSuccess != curr.actionSuccess && curr.actionSuccess),
      listener: (context, state) {
        if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
        if (state.actionSuccess) {
          SnackbarUtil.showSnackbar(context, message: state.actionMessage ?? 'Done.');
          _bloc.add(FetchNotificationsRequested(page: _page));
        }
      },
      builder: (context, state) {
        final data = state.notifications;
        final isLoading = state.isLoadingNotifications && data == null;

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: widget.onBackToUsers,
                              child: Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                            ),
                            const Text(
                              'Notification Center',
                              style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Manage Broadcasts',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Draft, schedule, and analyze clinical communications across the platform.',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _showCreateDialog,
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text(
                        'Create New Notification',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008B8B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (isLoading) ...[
                  _NotificationsShimmer(),
                ] else ...[
                  // ── Scheduled Notifications Card ───────────────────────────
                  _ScheduledCard(
                    pendingCount: data?.summary?.pendingCount ?? 0,
                    items: data?.scheduledNotifications ?? [],
                    onEdit: (item) => _onEdit(_NotificationEditData(
                      id: item.id!,
                      title: item.title,
                      audienceLabel: item.targetAudience,
                      scheduledAt: item.scheduledAt,
                    )),
                    onCancel: (id) => _onCancel(id),
                    onDelete: (id) => _onDelete(id),
                  ),
                  const SizedBox(height: 24),

                  // ── History Table Card ─────────────────────────────────────
                  _HistoryCard(
                    items: data?.history ?? [],
                    pagination: data?.pagination,
                    isRefreshing: state.isLoadingNotifications,
                    currentPage: _page,
                    onPageChanged: _goToPage,
                    onEdit: (item) => _onEdit(_NotificationEditData(
                      id: item.id!,
                      title: item.title,
                      audienceLabel: item.targetAudience,
                    )),
                    onDelete: (id) => _onDelete(id),
                    onCancel: (id) => _onCancel(id),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Scheduled notifications card ─────────────────────────────────────────────
class _ScheduledCard extends StatelessWidget {
  final int pendingCount;
  final List<ScheduledNotifications> items;
  final void Function(ScheduledNotifications item) onEdit;
  final void Function(int id) onCancel;
  final void Function(int id) onDelete;

  const _ScheduledCard({
    required this.pendingCount,
    required this.items,
    required this.onEdit,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              const Row(
                children: [
                  Icon(Icons.watch_later_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Scheduled Notifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$pendingCount PENDING',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'No scheduled notifications.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
            )
          else
            ...List.generate(
              items.length,
              (i) => Padding(
                padding: EdgeInsets.only(top: i == 0 ? 16 : 12),
                child: _ScheduledItem(
                  item: items[i],
                  onEdit: () => onEdit(items[i]),
                  onCancel: () => onCancel(items[i].id!),
                  onDelete: () => onDelete(items[i].id!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScheduledItem extends StatelessWidget {
  final ScheduledNotifications item;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const _ScheduledItem({
    required this.item,
    required this.onEdit,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F2F2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.watch_later_outlined, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 2),
                Text(
                  'Target: ${item.targetAudience ?? '—'} • Scheduled: ${_formatScheduled(item.scheduledAt)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (item.canEdit == true)
            _iconBtn(Icons.edit_outlined, 'Edit', onEdit),
          if (item.canCancel == true)
            _iconBtn(Icons.cancel_outlined, 'Cancel', onCancel),
          _iconBtn(Icons.delete_outline, 'Delete', onDelete, color: Colors.red.shade400),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, String tooltip, VoidCallback onTap, {Color? color}) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 16, color: color ?? AppColors.textMuted),
        onPressed: onTap,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
      ),
    );
  }
}

// ─── History card ──────────────────────────────────────────────────────────────
class _HistoryCard extends StatelessWidget {
  final List<History> items;
  final Pagination? pagination;
  final bool isRefreshing;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final void Function(History item) onEdit;
  final void Function(int id) onDelete;
  final void Function(int id) onCancel;

  const _HistoryCard({
    required this.items,
    required this.pagination,
    required this.isRefreshing,
    required this.currentPage,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final total = pagination?.total ?? 0;
    final perPage = pagination?.perPage ?? 10;
    final lastPage = pagination?.lastPage ?? 1;
    final start = (currentPage - 1) * perPage + 1;
    final end = min(currentPage * perPage, total);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Notification History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const Spacer(),
              if (isRefreshing)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 340,
              ),
              child: items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No notification history yet.',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ),
                    )
                  : Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2.2),
                        1: FlexColumnWidth(1.4),
                        2: FlexColumnWidth(1.0),
                        3: FlexColumnWidth(1.0),
                        4: FlexColumnWidth(0.7),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
                          ),
                          children: const [
                            _HeaderCell('NOTIFICATION TITLE'),
                            _HeaderCell('TARGET AUDIENCE'),
                            _HeaderCell('SENT DATE'),
                            _HeaderCell('STATUS'),
                            _HeaderCell('ACTIONS'),
                          ],
                        ),
                        ...items.map((item) => _buildHistoryRow(item)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 18),

          if (total > 0)
            _PaginationBar(
              currentPage: currentPage,
              lastPage: lastPage,
              total: total,
              start: start,
              end: end,
              onPageChanged: onPageChanged,
            ),
        ],
      ),
    );
  }

  TableRow _buildHistoryRow(History item) {
    final status = (item.status ?? '').toLowerCase();
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        // Title + type
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? '',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 2),
              Text(item.type ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
        // Audience badge
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.targetAudience ?? '',
                style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        // Sent date
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            _formatDate(item.sentAt),
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
          ),
        ),
        // Status badge
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: _StatusBadge(status: item.status ?? ''),
        ),
        // Actions popup
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textMuted),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              itemBuilder: (_) => _menuItems(status),
              onSelected: (action) {
                if (action == 'edit') onEdit(item);
                if (action == 'cancel') onCancel(item.id!);
                if (action == 'delete') onDelete(item.id!);
              },
            ),
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _menuItems(String status) {
    final items = <PopupMenuEntry<String>>[];

    if (status == 'draft') {
      items.add(_menuItem('edit', Icons.edit_outlined, 'Edit'));
    }
    if (status == 'scheduled') {
      items.add(_menuItem('edit', Icons.edit_outlined, 'Edit / Reschedule'));
      items.add(_menuItem('cancel', Icons.cancel_outlined, 'Cancel'));
    }

    if (items.isNotEmpty) {
      items.add(const PopupMenuDivider());
    }

    items.add(_menuItem('delete', Icons.delete_outline, 'Delete', color: Colors.red.shade600));
    return items;
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label, {Color? color}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 15, color: color ?? AppColors.textMuted),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 13, color: color ?? AppColors.textDark)),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    final Color color;
    final IconData icon;
    final String label;

    if (s == 'delivered') {
      color = Colors.green;
      icon = Icons.check_circle_outline_rounded;
      label = 'Delivered';
    } else if (s == 'scheduled') {
      color = Colors.blue;
      icon = Icons.watch_later_outlined;
      label = 'Scheduled';
    } else if (s == 'draft') {
      color = AppColors.textMuted;
      icon = Icons.edit_outlined;
      label = 'Draft';
    } else if (s == 'failed') {
      color = Colors.red;
      icon = Icons.error_outline;
      label = 'Failed';
    } else {
      color = AppColors.textMuted;
      icon = Icons.info_outline;
      label = status;
    }

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ─── Pagination bar ────────────────────────────────────────────────────────────
class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final int total;
  final int start;
  final int end;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.start,
    required this.end,
    required this.onPageChanged,
  });

  // Returns page numbers to display; -1 represents an ellipsis gap.
  List<int> _pageRange() {
    if (lastPage <= 7) return List.generate(lastPage, (i) => i + 1);

    final pages = <int>[1];

    if (currentPage > 3) pages.add(-1);

    final rangeStart = max(2, currentPage - 1);
    final rangeEnd = min(lastPage - 1, currentPage + 1);
    for (int p = rangeStart; p <= rangeEnd; p++) {
      pages.add(p);
    }

    if (currentPage < lastPage - 2) pages.add(-1);

    pages.add(lastPage);
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pageRange();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing $start–$end of $total notifications',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8)),
        ),
        Row(
          children: [
            _NavBtn(
              icon: Icons.chevron_left,
              enabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
            ),
            const SizedBox(width: 4),
            for (final p in pages)
              p == -1
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('…', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    )
                  : _PageBtn(
                      page: p,
                      isActive: p == currentPage,
                      onTap: () => onPageChanged(p),
                    ),
            const SizedBox(width: 4),
            _NavBtn(
              icon: Icons.chevron_right,
              enabled: currentPage < lastPage,
              onTap: () => onPageChanged(currentPage + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavBtn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(6),
          color: enabled ? Colors.white : const Color(0xFFF7F7F7),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.textDark : AppColors.borderLight,
        ),
      ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageBtn({required this.page, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: isActive ? null : onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF004D4D) : Colors.white,
            border: Border.all(
              color: isActive ? const Color(0xFF004D4D) : AppColors.borderLight,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer ───────────────────────────────────────────────────────────────────
class _NotificationsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSkeleton.textBar(width: 180, height: 14),
                  AppSkeleton(width: 70, height: 24),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerItem(),
              const SizedBox(height: 12),
              _shimmerItem(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSkeleton.textBar(width: 160, height: 16),
              const SizedBox(height: 20),
              ...List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(flex: 22, child: AppSkeleton.textBar(height: 13)),
                      SizedBox(width: 16),
                      Expanded(flex: 14, child: AppSkeleton.textBar(height: 13)),
                      SizedBox(width: 16),
                      Expanded(flex: 10, child: AppSkeleton.textBar(height: 13)),
                      SizedBox(width: 16),
                      Expanded(flex: 10, child: AppSkeleton.textBar(height: 13)),
                      SizedBox(width: 16),
                      Expanded(flex: 7, child: AppSkeleton.textBar(height: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Row(
        children: [
          AppSkeleton(width: 36, height: 36),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 200, height: 13),
                SizedBox(height: 6),
                AppSkeleton.textBar(width: 280, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }
}

// ─── Notification form dialog (create + edit) ──────────────────────────────────
class _NotificationFormDialog extends StatefulWidget {
  final _NotificationEditData? editData;

  const _NotificationFormDialog({this.editData});

  @override
  State<_NotificationFormDialog> createState() => _NotificationFormDialogState();
}

class _NotificationFormDialogState extends State<_NotificationFormDialog> {
  late final NotificationBloc _bloc;

  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String _audienceSegment = 'all_users';
  DateTime? _scheduledDateTime;

  bool get _isEditMode => widget.editData != null;

  @override
  void initState() {
    super.initState();
    _bloc = locator<NotificationBloc>();
    _bloc.add(FetchVerifiedDoctorsCountRequested());

    if (_isEditMode) {
      final ed = widget.editData!;
      _titleCtrl.text = ed.title ?? '';
      final key = _labelToKey(ed.audienceLabel);
      if (key != null && _audienceOptions.containsKey(key)) {
        _audienceSegment = key;
      }
      if (ed.scheduledAt != null) {
        _scheduledDateTime = DateTime.tryParse(ed.scheduledAt!)?.toLocal();
      }
    }
  }

  @override
  void dispose() {
    _bloc.close();
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF004D4D)),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _scheduledDateTime != null
          ? TimeOfDay(hour: _scheduledDateTime!.hour, minute: _scheduledDateTime!.minute)
          : TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF004D4D)),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() {
      _scheduledDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit(String status) {
    final title = _titleCtrl.text.trim();
    final message = _messageCtrl.text.trim();
    if (title.isEmpty || message.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Title and message are required.', isError: true);
      return;
    }
    final request = CreateNotificationRequest(
      title: title,
      message: message,
      audienceSegment: _audienceSegment,
      scheduleAt: _scheduledDateTime?.toUtc().toIso8601String(),
      status: status,
    );
    if (_isEditMode) {
      _bloc.add(UpdateNotificationRequested(id: widget.editData!.id, request: request));
    } else {
      _bloc.add(CreateNotificationRequested(request));
    }
  }

  String get _formattedSchedule {
    if (_scheduledDateTime == null) return '';
    final d = _scheduledDateTime!;
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year}  $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      bloc: _bloc,
      listenWhen: (prev, curr) =>
          prev.submitSuccess != curr.submitSuccess || prev.error != curr.error,
      listener: (context, state) {
        if (state.submitSuccess) {
          Navigator.of(context).pop();
          SnackbarUtil.showSnackbar(
            context,
            message: _isEditMode ? 'Notification updated successfully.' : 'Notification created successfully.',
          );
        }
        if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      builder: (context, state) {
        final isScheduled = _scheduledDateTime != null;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    color: const Color(0xFF004D4D),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditMode ? 'Edit Notification' : 'Create New Notification',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEditMode
                                  ? 'Update the broadcast message details'
                                  : 'Compose a broadcast message for your clinicians',
                              style: const TextStyle(color: Color(0xFFB3D1D1), fontSize: 12),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: state.isSubmitting ? null : () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Form
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Notification Title'),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: _titleCtrl,
                          hintText: 'e.g. Important Clinical Update: Pulmonary Care',
                        ),
                        const SizedBox(height: 20),

                        _label('Message Content'),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: _messageCtrl,
                          hintText: 'Enter the main body of your message here…',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),

                        _label('Audience Segment'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF2F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _audienceSegment,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                              style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500),
                              items: _audienceOptions.entries
                                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                                  .toList(),
                              onChanged: (val) => setState(() => _audienceSegment = val!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _label('Schedule Date & Time'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickSchedule,
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF2F7),
                              borderRadius: BorderRadius.circular(8),
                              border: isScheduled ? Border.all(color: const Color(0xFF004D4D)) : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: isScheduled ? const Color(0xFF004D4D) : const Color(0xFFA9A9A9),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isScheduled ? _formattedSchedule : 'Send immediately (tap to schedule)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isScheduled ? AppColors.textDark : const Color(0xFFA9A9A9),
                                      fontWeight: isScheduled ? FontWeight.w500 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isScheduled)
                                  GestureDetector(
                                    onTap: () => setState(() => _scheduledDateTime = null),
                                    child: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Info panel
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: Colors.orangeAccent),
                              const SizedBox(width: 12),
                              Expanded(
                                child: state.isLoadingCount
                                    ? const Text(
                                        'Calculating recipients…',
                                        style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontStyle: FontStyle.italic),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          style: const TextStyle(color: AppColors.textDark, fontSize: 12, height: 1.4),
                                          children: [
                                            TextSpan(
                                              text: isScheduled
                                                  ? 'This notification will be delivered on $_formattedSchedule to approximately '
                                                  : 'This notification will be delivered instantly to approximately ',
                                            ),
                                            TextSpan(
                                              text: state.verifiedDoctorsCount != null
                                                  ? '${state.verifiedDoctorsCount} verified doctor${state.verifiedDoctorsCount == 1 ? '' : 's'}'
                                                  : 'all verified doctors',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action bar
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: state.isSubmitting ? null : () => _submit('draft'),
                          child: const Text(
                            'Save as Draft',
                            style: TextStyle(color: Color(0xFF4A5568), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => _submit(isScheduled ? 'scheduled' : 'published'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D4D),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: state.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  _isEditMode
                                      ? (isScheduled ? 'Update Schedule' : 'Update & Send')
                                      : (isScheduled ? 'Schedule Broadcast' : 'Send Broadcast Now'),
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA9A9A9), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFEDF2F7),
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}

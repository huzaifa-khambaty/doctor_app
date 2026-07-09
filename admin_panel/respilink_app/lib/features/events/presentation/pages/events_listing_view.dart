import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_model.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_state.dart';

class EventManagementContent extends StatelessWidget {
  const EventManagementContent({
    super.key,
    required this.onCreateEventClicked,
    required this.onEventTapped,
  });

  final VoidCallback onCreateEventClicked;
  final void Function(Events) onEventTapped;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listenWhen: (prev, curr) => prev.error != curr.error && curr.error != null,
      listener: (context, state) {
        if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventSearchBarHeader(onCreateEventClicked: onCreateEventClicked),
              const SizedBox(height: 32),
              _EventTitleRowSection(onCreateEventClicked: onCreateEventClicked),
              const SizedBox(height: 24),
              const _EventMetricsSection(),
              const SizedBox(height: 24),
              const _EventTypeFiltersRow(),
              const SizedBox(height: 20),
              _EventDataTable(onEventTapped: onEventTapped),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// Search Header
// =========================================================================

class _EventSearchBarHeader extends StatelessWidget {
  const _EventSearchBarHeader({required this.onCreateEventClicked});

  final VoidCallback onCreateEventClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search events by title or type...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
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
}

// =========================================================================
// Title + Schedule Button
// =========================================================================

class _EventTitleRowSection extends StatelessWidget {
  const _EventTitleRowSection({required this.onCreateEventClicked});

  final VoidCallback onCreateEventClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EVENT MANAGEMENT',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0)),
            SizedBox(height: 4),
            Text('Events & Webinars',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 16, color: AppColors.textDark),
              label: const Text('Export', style: TextStyle(color: AppColors.textDark, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.borderLight),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onCreateEventClicked,
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text('Schedule New Event',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =========================================================================
// Metrics + Next Event
// =========================================================================

class _EventMetricsSection extends StatelessWidget {
  const _EventMetricsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        final events = state.events?.data ?? [];
        final nextEvent = _firstOrNull(events, (e) => e.isLive || e.isUpcoming);
        final total = state.events?.total ?? 0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 900;
            return Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: wide ? 2 : 0,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _MetricCard(
                        title: 'TOTAL EVENTS',
                        value: total == 0 ? '—' : total.toString(),
                        subtitle: 'All Time',
                        subColor: AppColors.textMuted,
                        icon: Icons.event_outlined,
                      ),
                      _MetricCard(
                        title: 'UPCOMING',
                        value: events.where((e) => e.isUpcoming).length.toString(),
                        subtitle: 'Scheduled',
                        subColor: AppColors.primary,
                        icon: Icons.schedule_outlined,
                      ),
                      _MetricCard(
                        title: 'LIVE NOW',
                        value: events.where((e) => e.isLive).length.toString(),
                        subtitle: events.any((e) => e.isLive) ? 'In Progress' : 'None Active',
                        subColor:
                            events.any((e) => e.isLive) ? AppColors.errorRed : AppColors.textMuted,
                        icon: Icons.live_tv_outlined,
                      ),
                    ],
                  ),
                ),
                wide ? const SizedBox(width: 16) : const SizedBox(height: 16),
                Expanded(
                  flex: wide ? 1 : 0,
                  child: nextEvent != null
                      ? _NextEventPanel(event: nextEvent)
                      : Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: const Center(
                            child: Text('No upcoming events',
                                style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static T? _firstOrNull<T>(List<T> list, bool Function(T) test) {
    for (final e in list) {
      if (test(e)) return e;
    }
    return null;
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color subColor;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5)),
              Icon(icon, color: AppColors.textMuted.withValues(alpha: 0.6), size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: subColor)),
        ],
      ),
    );
  }
}

class _NextEventPanel extends StatelessWidget {
  final Events event;

  const _NextEventPanel({required this.event});

  @override
  Widget build(BuildContext context) {
    final isLive = event.isLive;
    final startDt = event.startDateTime;
    final dateStr =
        startDt != null ? DateFormat('MMM d, yyyy • h:mm a').format(startDt) : '—';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLive
              ? [const Color(0xFF9B2C2C), const Color(0xFFC53030)]
              : [const Color(0xFF0A5C5A), const Color(0xFF0E7B7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLive) ...[
                _LiveDot(),
                const SizedBox(width: 6),
                const Text('LIVE NOW',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
              ] else
                const Text('NEXT EVENT',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 8),
          Text(event.title ?? '—',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 11, color: Colors.white70),
              const SizedBox(width: 4),
              Expanded(
                child: Text(dateStr,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          if (event.location != null && event.location!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 11, color: Colors.white70),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(event.location!,
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// =========================================================================
// Type Filter Chips
// =========================================================================

class _EventTypeFiltersRow extends StatefulWidget {
  const _EventTypeFiltersRow();

  @override
  State<_EventTypeFiltersRow> createState() => _EventTypeFiltersRowState();
}

class _EventTypeFiltersRowState extends State<_EventTypeFiltersRow> {
  String? _activeType;

  void _dispatch(String? type) {
    setState(() => _activeType = type);
    context.read<EventsBloc>().add(FetchEventsRequested(type: type));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              _FilterChip(label: 'All Events', isActive: _activeType == null, onTap: () => _dispatch(null)),
              _FilterChip(
                  label: 'Webinars', isActive: _activeType == 'webinar', onTap: () => _dispatch('webinar')),
              _FilterChip(
                  label: 'Conferences',
                  isActive: _activeType == 'conference',
                  onTap: () => _dispatch('conference')),
              _FilterChip(
                  label: 'Workshops',
                  isActive: _activeType == 'workshop',
                  onTap: () => _dispatch('workshop')),
            ],
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.textDark),
          label: const Text('Filters', style: TextStyle(color: AppColors.textDark, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.borderLight),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// Events Data Table
// =========================================================================

class _EventDataTable extends StatelessWidget {
  final void Function(Events) onEventTapped;

  const _EventDataTable({required this.onEventTapped});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        final events = state.events?.data ?? [];
        final isLoading = state.isLoading;

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
                  0: FlexColumnWidth(2.8),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(2.0),
                  3: FlexColumnWidth(1.3),
                  4: FlexColumnWidth(1.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildHeaderRow(),
                  if (isLoading)
                    ..._buildSkeletonRows()
                  else if (events.isEmpty)
                    _buildEmptyRow()
                  else
                    ...events.map((e) => _buildEventRow(context, e, state, onEventTapped)),
                ],
              ),
              _PaginationFooter(model: state.events, activeType: state.activeType),
            ],
          ),
        );
      },
    );
  }

  TableRow _buildHeaderRow() {
    const style =
        TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted);
    return const TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(padding: EdgeInsets.all(16), child: Text('EVENT', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('TYPE', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('DATE & TIME', style: style)),
        Padding(padding: EdgeInsets.all(16), child: Text('STATUS', style: style)),
        Padding(
            padding: EdgeInsets.all(16),
            child: Text('ACTIONS', style: style, textAlign: TextAlign.right)),
      ],
    );
  }

  TableRow _buildEventRow(BuildContext context, Events e, EventsState state, void Function(Events) onTap) {
    final status = e.computedStatus;
    final startDt = e.startDateTime;
    final dateStr = startDt != null ? DateFormat('MMM d, yyyy • h:mm a').format(startDt) : '—';

    final typeColor = switch (e.type?.toLowerCase()) {
      'conference' => const Color(0xFF553C9A),
      'workshop' => const Color(0xFF744210),
      _ => const Color(0xFF0A5C5A),
    };

    final (statusColor, statusBg, statusLabel) = switch (status) {
      'live' => (AppColors.errorRed, const Color(0xFFFFF5F5), 'LIVE'),
      'upcoming' => (AppColors.primary, const Color(0xFFE6F4F4), 'UPCOMING'),
      'ended' => (AppColors.textMuted, const Color(0xFFF7FAFC), 'ENDED'),
      _ => (AppColors.warningOrange, const Color(0xFFFFFAF0), status.toUpperCase()),
    };

    final joinLink = e.externalJoinLink ?? e.recordingLink;

    return TableRow(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.title ?? '—',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              if (e.location != null && e.location!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 10, color: AppColors.textMuted),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(e.location!,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
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
                color: typeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                (e.type ?? 'event').toUpperCase(),
                style:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: typeColor),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(dateStr,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration:
                  BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (status == 'live')
                    _LiveDot()
                  else
                    Icon(Icons.fiber_manual_record, color: statusColor, size: 8),
                  const SizedBox(width: 4),
                  Text(statusLabel,
                      style: TextStyle(
                          color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (status == 'live' && joinLink != null && joinLink.isNotEmpty)
                Tooltip(
                  message: joinLink,
                  child: IconButton(
                    icon: const Icon(Icons.videocam_outlined, size: 18, color: AppColors.errorRed),
                    onPressed: () => Clipboard.setData(ClipboardData(text: joinLink)),
                    tooltip: 'Copy join link',
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.textMuted),
                onPressed: () => onTap(e),
                tooltip: 'View details',
              ),
              _EventRowMenu(event: e, state: state),
            ],
          ),
        ),
      ],
    );
  }

  List<TableRow> _buildSkeletonRows() {
    final shBox =
        BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4));
    return List.generate(
      5,
      (_) => TableRow(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 12, width: 160, decoration: shBox),
              const SizedBox(height: 6),
              Container(height: 10, width: 90, decoration: shBox),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(height: 22, width: 70, decoration: shBox)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 12, width: 80, decoration: shBox),
              const SizedBox(height: 6),
              Container(height: 10, width: 50, decoration: shBox),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  height: 22,
                  width: 72,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12)))),
          const SizedBox(),
        ],
      ),
    );
  }

  TableRow _buildEmptyRow() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Text('No events found.', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
        ),
        SizedBox(),
        SizedBox(),
        SizedBox(),
        SizedBox(),
      ],
    );
  }
}

// =========================================================================
// Per-row popup menu
// =========================================================================

class _EventRowMenu extends StatelessWidget {
  final Events event;
  final EventsState state;

  const _EventRowMenu({required this.event, required this.state});

  bool get _isPublished => event.status == 'published';
  bool get _isActioning =>
      (state.isTogglingStatus && state.togglingEventId == event.id) ||
      (state.isDeleting && state.deletingEventId == event.id);

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Delete Event',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
            content: Text(
              'Are you sure you want to delete "${event.title ?? 'this event'}"? This action cannot be undone.',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isActioning) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textMuted),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      onSelected: (value) async {
        if (value == 'toggle') {
          context.read<EventsBloc>().add(
                ToggleEventStatusRequested(event.id!, _isPublished ? 'draft' : 'published'));
        } else if (value == 'delete') {
          final confirmed = await _confirmDelete(context);
          if (confirmed && context.mounted) {
            context.read<EventsBloc>().add(DeleteEventRequested(event.id!));
          }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                _isPublished ? Icons.unpublished_outlined : Icons.publish_outlined,
                size: 16,
                color: _isPublished ? AppColors.textMuted : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                _isPublished ? 'Unpublish' : 'Publish',
                style: TextStyle(
                  fontSize: 13,
                  color: _isPublished ? AppColors.textDark : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 16, color: AppColors.errorRed),
              const SizedBox(width: 10),
              const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// Pagination Footer
// =========================================================================

class _PaginationFooter extends StatelessWidget {
  final EventListingModel? model;
  final String? activeType;

  const _PaginationFooter({this.model, this.activeType});

  void _goToPage(BuildContext context, int page) {
    context.read<EventsBloc>().add(FetchEventsRequested(page: page, type: activeType));
  }

  List<int?> _pageNumbers(int current, int last) {
    if (last <= 7) return List.generate(last, (i) => i + 1);
    final Set<int> show = {1, last, current};
    if (current > 1) show.add(current - 1);
    if (current < last) show.add(current + 1);
    final sorted = show.toList()..sort();
    final result = <int?>[];
    for (int i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] - sorted[i - 1] > 1) result.add(null);
      result.add(sorted[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final current = model?.currentPage ?? 1;
    final last = model?.lastPage ?? 1;
    final from = model?.from ?? 0;
    final to = model?.to ?? 0;
    final total = model?.total ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            total == 0 ? '' : 'Showing $from – $to of $total events',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          if (last > 1)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_left, size: 18),
                  onPressed: current > 1 ? () => _goToPage(context, current - 1) : null,
                ),
                ..._pageNumbers(current, last).map((page) {
                  if (page == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('…', style: TextStyle(color: AppColors.textMuted)),
                    );
                  }
                  return _PageBtn(
                    page: page.toString(),
                    isActive: page == current,
                    onTap: () => _goToPage(context, page),
                  );
                }),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_right, size: 18),
                  onPressed: current < last ? () => _goToPage(context, current + 1) : null,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageBtn({required this.page, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.sidebarBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          page,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// Live Dot (pulsing)
// =========================================================================

class _LiveDot extends StatefulWidget {
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _anim =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: AppColors.errorRed, shape: BoxShape.circle),
      ),
    );
  }
}

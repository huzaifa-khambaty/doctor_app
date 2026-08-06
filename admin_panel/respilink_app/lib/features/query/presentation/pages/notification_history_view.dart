import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_bloc.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_event.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_state.dart';
import 'package:respilink_app/injections.dart';

class NotificationHistoryView extends StatelessWidget {
  final VoidCallback onBackToUsers;

  const NotificationHistoryView({super.key, required this.onBackToUsers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Breadcrumbs & Top Section Header Row
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
                          onTap: () => onBackToUsers.call(),
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
                          child: Icon(
                            Icons.chevron_right,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Text(
                          'Notification Center',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage Broadcasts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Draft, schedule, and analyze clinical communications across the platform.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showCreateNotificationDialog(context);
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    'Create New Notification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF008B8B,
                    ), // Custom bright teal theme match
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Scheduled Notifications Card (Pending Section)
            Container(
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
                      Row(
                        children: const [
                          Icon(
                            Icons.watch_later_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Scheduled Notifications',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF8FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '3 PENDING',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildScheduledItem(
                    icon: Icons.send_outlined,
                    iconBg: const Color(0xFFE6F2F2),
                    iconColor: AppColors.primary,
                    title: 'Weekly MedSynapse Insights #24',
                    meta:
                        'Target: All Verified Clinicians • Scheduled: Oct 28, 09:00 AM',
                  ),
                  const SizedBox(height: 12),
                  _buildScheduledItem(
                    icon: Icons.refresh_rounded,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: Colors.blue,
                    title: 'System Maintenance Alert',
                    meta: 'Target: All Users • Scheduled: Oct 30, 11:30 PM',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Notification History Card Block (Data Table Display)
            Container(
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Spacer(),
                      _buildHistoryFilterButton('Filter by Status'),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'Export Data',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Custom Scrollable Presentation Data Table View Matrix
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 340,
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2.2),
                          1: FlexColumnWidth(1.4),
                          2: FlexColumnWidth(1.0),
                          3: FlexColumnWidth(1.0),
                          4: FlexColumnWidth(0.7),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          // Header Row
                          TableRow(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.borderLight,
                                ),
                              ),
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'NOTIFICATION TITLE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'TARGET AUDIENCE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'SENT DATE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'STATUS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'ACTIONS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Data Row 1
                          _buildHistoryRow(
                            title: 'New COVID-19 Protocol Update',
                            type: 'Push Notification',
                            badgeText: 'Specialty: Pulmonology',
                            badgeBg: const Color(0xFFEFF6FF),
                            badgeColor: Colors.blue,
                            date: 'Oct 24, 2023',
                          ),
                          // Data Row 2
                          _buildHistoryRow(
                            title: 'MedSynapse Conference Invitations',
                            type: 'In-App Message',
                            badgeText: 'Segment: Verified',
                            badgeBg: const Color(0xFFF3E8FF),
                            badgeColor: Colors.purple,
                            date: 'Oct 20, 2023',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Pagination Footer Area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing 1-10 of 124 notifications',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted.withValues(alpha: 0.8),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: null, // Disabled in mock preview
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              side: const BorderSide(
                                color: AppColors.borderLight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.textDark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pending Scheduled List Item Builder Utility
  Widget _buildScheduledItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String meta,
  }) {
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
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.textMuted,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.cancel_outlined,
              size: 16,
              color: AppColors.textMuted,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Dropdown-style Filter Button Builder
  Widget _buildHistoryFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  // Custom Content Table Row Builder Component
  TableRow _buildHistoryRow({
    required String title,
    required String type,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String date,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        // Title Column
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        // Audience Badge Column
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Sent Date Column
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Status Column
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: const [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 14,
                color: Colors.green,
              ),
              SizedBox(width: 4),
              Text(
                'Delivered',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Actions Button Column
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: IconButton(
            alignment: Alignment.centerLeft,
            icon: const Icon(
              Icons.more_vert,
              size: 16,
              color: AppColors.textMuted,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  void showCreateNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _CreateNotificationDialog(),
    );
  }
}

// ─── Audience segment options ────────────────────────────────────────────────
const _audienceOptions = {
  'all_users': 'All Users',
};

class _CreateNotificationDialog extends StatefulWidget {
  const _CreateNotificationDialog();

  @override
  State<_CreateNotificationDialog> createState() => _CreateNotificationDialogState();
}

class _CreateNotificationDialogState extends State<_CreateNotificationDialog> {
  late final NotificationBloc _bloc;

  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String _audienceSegment = 'all_users';
  DateTime? _scheduledDateTime;

  @override
  void initState() {
    super.initState();
    _bloc = locator<NotificationBloc>();
    _bloc.add(FetchVerifiedDoctorsCountRequested());
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
      initialDate: DateTime.now().add(const Duration(days: 1)),
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
      initialTime: TimeOfDay.now(),
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
    _bloc.add(CreateNotificationRequested(
      CreateNotificationRequest(
        title: title,
        message: message,
        audienceSegment: _audienceSegment,
        scheduleAt: _scheduledDateTime?.toIso8601String(),
        status: status,
      ),
    ));
  }

  String get _formattedSchedule {
    if (_scheduledDateTime == null) return '';
    final d = _scheduledDateTime!;
    return '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
          SnackbarUtil.showSnackbar(context, message: 'Notification created successfully');
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
                          children: const [
                            Text(
                              'Create New Notification',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Compose a broadcast message for your clinicians',
                              style: TextStyle(color: Color(0xFFB3D1D1), fontSize: 12),
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
                        _inputField(controller: _titleCtrl, hintText: 'e.g. Important Clinical Update: Pulmonary Care'),
                        const SizedBox(height: 20),

                        _label('Message Content'),
                        const SizedBox(height: 8),
                        _inputField(controller: _messageCtrl, hintText: 'Enter the main body of your message here...', maxLines: 4),
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
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
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
                                  isScheduled ? 'Schedule Broadcast' : 'Send Broadcast Now',
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

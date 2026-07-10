import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_model.dart';
import 'package:respilink_app/features/events/data/model/request/create_event_request.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_state.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/service/image_picker_service.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class ScheduleEventContent extends StatefulWidget {
  final VoidCallback onBackToEvents;
  final Events? existingEvent;

  const ScheduleEventContent({
    super.key,
    required this.onBackToEvents,
    this.existingEvent,
  });

  @override
  State<ScheduleEventContent> createState() => _ScheduleEventContentState();
}

class _ScheduleEventContentState extends State<ScheduleEventContent> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _joinLinkController = TextEditingController();

  int _activeEventTypeIndex = 0;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _enableQnA = true;
  bool _certificateOfParticipation = false;
  bool _sendEmailReminders = true;
  final List<Practioners> _selectedSpeakers = [];
  PickedImage? _pickedBanner;
  Uint8List? _bannerPreviewBytes;
  String? _existingBannerUrl;

  bool get _isViewMode => widget.existingEvent != null;

  static const _eventTypes = ['webinar', 'conference', 'workshop'];
  static const _eventTypeLabels = ['Webinar', 'Conference', 'Workshop'];
  static const _eventTypeIcons = [
    Icons.videocam_outlined,
    Icons.badge_outlined,
    Icons.build_circle_outlined,
  ];

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(FetchSpeakersRequested());
    _prefillFromExisting();
  }

  void _prefillFromExisting() {
    final e = widget.existingEvent;
    if (e == null) return;

    _titleController.text = e.title ?? '';
    _locationController.text = e.location ?? '';
    _descriptionController.text = e.description ?? '';
    _joinLinkController.text = e.externalJoinLink ?? '';

    final typeIdx = _eventTypes.indexOf(e.type ?? '');
    _activeEventTypeIndex = typeIdx >= 0 ? typeIdx : 0;

    _enableQnA = e.enableQaSession ?? true;
    _certificateOfParticipation = e.certificateOfParticipation ?? false;
    _sendEmailReminders = e.sendEmailReminders ?? true;

    _existingBannerUrl = (e.bannerUrl != null && e.bannerUrl!.isNotEmpty)
        ? e.bannerUrl
        : (e.bannerPath != null && e.bannerPath!.isNotEmpty
            ? '${ApiEndpoints.imageUrl}${e.bannerPath}'
            : null);

    final speakers = e.speakers ?? [];
    _selectedSpeakers.clear();
    _selectedSpeakers.addAll(
      speakers.map((s) => Practioners()
        ..id = s.id
        ..fullName = s.fullName),
    );

    final startDt = e.startDateTime;
    if (startDt != null) {
      _startDate = DateTime(startDt.year, startDt.month, startDt.day);
      _startTime = TimeOfDay(hour: startDt.hour, minute: startDt.minute);
    }
    final endDt = e.endDateTime;
    if (endDt != null) {
      _endDate = DateTime(endDt.year, endDt.month, endDt.day);
      _endTime = TimeOfDay(hour: endDt.hour, minute: endDt.minute);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _joinLinkController.dispose();
    super.dispose();
  }

  String _formatDateDisplay(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  String _formatTimeDisplay(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  String _toIso8601(DateTime date, TimeOfDay time) {
    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickBanner() async {
    final result = await ImagePickerService.instance.pickFromGallery();
    if (result.isSuccess && result.image != null) {
      setState(() {
        _pickedBanner = result.image;
        _bannerPreviewBytes = result.image!.bytes;
      });
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  void _publish() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Event title is required', isError: true);
      return;
    }
    if (_startDate == null || _startTime == null) {
      SnackbarUtil.showSnackbar(context, message: 'Start date and time are required', isError: true);
      return;
    }
    if (_endDate == null || _endTime == null) {
      SnackbarUtil.showSnackbar(context, message: 'End date and time are required', isError: true);
      return;
    }

    final request = CreateEventRequest(
      title: title,
      type: _eventTypes[_activeEventTypeIndex],
      speakers: _selectedSpeakers.map((s) => s.id!).toList(),
      startsAt: _toIso8601(_startDate!, _startTime!),
      endsAt: _toIso8601(_endDate!, _endTime!),
      timezone: 'UTC',
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      externalJoinLink: _joinLinkController.text.trim().isEmpty ? null : _joinLinkController.text.trim(),
      recordingLink: null,
      enableQaSession: _enableQnA,
      certificateOfParticipation: _certificateOfParticipation,
      sendEmailReminders: _sendEmailReminders,
    );

    context.read<EventsBloc>().add(CreateEventRequested(request, banner: _pickedBanner));
  }

  void _update() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Event title is required', isError: true);
      return;
    }
    if (_startDate == null || _startTime == null) {
      SnackbarUtil.showSnackbar(context, message: 'Start date and time are required', isError: true);
      return;
    }
    if (_endDate == null || _endTime == null) {
      SnackbarUtil.showSnackbar(context, message: 'End date and time are required', isError: true);
      return;
    }

    final request = CreateEventRequest(
      title: title,
      type: _eventTypes[_activeEventTypeIndex],
      speakers: _selectedSpeakers.map((s) => s.id!).toList(),
      startsAt: _toIso8601(_startDate!, _startTime!),
      endsAt: _toIso8601(_endDate!, _endTime!),
      timezone: 'UTC',
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      externalJoinLink: _joinLinkController.text.trim().isEmpty ? null : _joinLinkController.text.trim(),
      recordingLink: null,
      enableQaSession: _enableQnA,
      certificateOfParticipation: _certificateOfParticipation,
      sendEmailReminders: _sendEmailReminders,
    );

    context.read<EventsBloc>().add(
          UpdateEventRequested(widget.existingEvent!.id!, request, banner: _pickedBanner));
  }

  Future<void> _showSpeakerDialog(List<Practioners> available) async {
    final result = await showDialog<List<Practioners>>(
      context: context,
      builder: (_) => _SpeakerSelectionDialog(
        available: available,
        initialSelected: List.from(_selectedSpeakers),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedSpeakers.clear();
        _selectedSpeakers.addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool stackVertically = MediaQuery.of(context).size.width < 1050;

    InputDecoration fieldDeco(String hint, {Widget? prefixIcon, Widget? suffixIcon}) => InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        );

    return BlocListener<EventsBloc, EventsState>(
      listenWhen: (prev, curr) =>
          (prev.createSuccess != curr.createSuccess && curr.createSuccess) ||
          (prev.updateSuccess != curr.updateSuccess && curr.updateSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.createSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Event published successfully!');
          widget.onBackToEvents();
        } else if (state.updateSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Event updated successfully!');
          widget.onBackToEvents();
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back nav
              InkWell(
                onTap: widget.onBackToEvents,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 14, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text('Back to Events',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isViewMode ? 'Event Details' : 'Schedule New Event',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                _isViewMode
                    ? 'Viewing details for this event. Fields are pre-filled from the recorded data.'
                    : 'Set up a new clinical session, webinar, or medical workshop for the community.',
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),

              // Two-column layout
              Flex(
                direction: stackVertically ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: form fields
                  Expanded(
                    flex: stackVertically ? 0 : 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FormBlockCard(
                          title: 'Event Details',
                          icon: Icons.info_outline_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Event Title',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _titleController,
                                decoration: fieldDeco('e.g., Advances in COPD Management 2024'),
                              ),
                              const SizedBox(height: 16),
                              const Text('Event Type',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 6),
                              _buildEventTypeSelector(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Start Date',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _pickStartDate,
                                          child: AbsorbPointer(
                                            child: TextField(
                                              decoration: fieldDeco(
                                                _startDate != null ? _formatDateDisplay(_startDate!) : 'mm/dd/yyyy',
                                                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Start Time',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _pickStartTime,
                                          child: AbsorbPointer(
                                            child: TextField(
                                              decoration: fieldDeco(
                                                _startTime != null ? _formatTimeDisplay(_startTime!) : '--:-- --',
                                                prefixIcon: const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('End Date',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _pickEndDate,
                                          child: AbsorbPointer(
                                            child: TextField(
                                              decoration: fieldDeco(
                                                _endDate != null ? _formatDateDisplay(_endDate!) : 'mm/dd/yyyy',
                                                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('End Time',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _pickEndTime,
                                          child: AbsorbPointer(
                                            child: TextField(
                                              decoration: fieldDeco(
                                                _endTime != null ? _formatTimeDisplay(_endTime!) : '--:-- --',
                                                prefixIcon: const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text('Location / Link',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _locationController,
                                decoration: fieldDeco('Hospital name or physical address',
                                    prefixIcon: const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted)),
                              ),
                              const SizedBox(height: 16),
                              const Text('External Join Link (optional)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _joinLinkController,
                                decoration: fieldDeco('https://zoom.us/j/...',
                                    prefixIcon: const Icon(Icons.link, size: 16, color: AppColors.textMuted)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FormBlockCard(
                          title: 'Description',
                          icon: Icons.notes_rounded,
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: fieldDeco('Provide a detailed agenda and clinical objectives...'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  stackVertically ? const SizedBox(height: 20) : const SizedBox(width: 20),

                  // Right: assets & controls
                  Expanded(
                    flex: stackVertically ? 0 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner upload
                        _FormBlockCard(
                          title: 'Banner Image',
                          icon: Icons.image_outlined,
                          child: GestureDetector(
                            onTap: _pickBanner,
                            child: _bannerPreviewBytes != null
                                ? SizedBox(
                                    height: 140,
                                    width: double.infinity,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.memory(
                                            _bannerPreviewBytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              _pickedBanner = null;
                                              _bannerPreviewBytes = null;
                                            }),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _existingBannerUrl != null && _existingBannerUrl!.isNotEmpty
                                    ? SizedBox(
                                        height: 140,
                                        width: double.infinity,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                _existingBannerUrl!,
                                                fit: BoxFit.cover,
                                                webHtmlElementStrategy:
                                                    WebHtmlElementStrategy.prefer,
                                                errorBuilder: (_, object, err) => const Center(
                                                  child: Icon(Icons.broken_image_outlined,
                                                      color: Colors.grey, size: 32),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.edit_outlined, color: Colors.white, size: 12),
                                                    SizedBox(width: 4),
                                                    Text('Replace', style: TextStyle(color: Colors.white, fontSize: 11)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: AppColors.scaffoldBg.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.borderLight),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: AppColors.primary.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6)),
                                              child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 20),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text('Click to upload banner',
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                            const SizedBox(height: 4),
                                            Text('1200 × 630px recommended\n(PNG, JPG)',
                                                style: TextStyle(fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.8)),
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Faculty / Speaker selection
                        BlocBuilder<EventsBloc, EventsState>(
                          builder: (context, state) {
                            return _FormBlockCard(
                              title: 'Faculty',
                              icon: Icons.people_outline,
                              trailingAction: InkWell(
                                onTap: state.isLoadingSpeakers
                                    ? null
                                    : () => _showSpeakerDialog(state.speakers),
                                child: const Text('Add Speaker',
                                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              child: Column(
                                children: [
                                  if (state.isLoadingSpeakers)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                        ),
                                      ),
                                    )
                                  else if (_selectedSpeakers.isEmpty)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.scaffoldBg.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                                      ),
                                      child: const Center(
                                        child: Text('No speakers selected',
                                            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                      ),
                                    )
                                  else
                                    ..._selectedSpeakers.map((s) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: AppColors.borderLight),
                                            ),
                                            child: Row(
                                              children: [
                                                AppNetworkImage(
                                                  imageUrl: '${s.photoUrl ?? s.photoPath}',
                                                  width: 32,
                                                  height: 32,
                                                  isCircle: true,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(s.fullName ?? '—',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppColors.textDark)),
                                                      Text(s.qualifications ?? s.hospitalAffiliation ?? '—',
                                                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.cancel, size: 16, color: AppColors.errorRed),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () => setState(() => _selectedSpeakers.remove(s)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Engagement controls
                        _FormBlockCard(
                          title: 'Engagement',
                          icon: Icons.analytics_outlined,
                          child: Column(
                            children: [
                              _buildSwitchRow('Enable Q&A Session', _enableQnA, (v) => setState(() => _enableQnA = v)),
                              const Divider(color: AppColors.borderLight, height: 16),
                              _buildSwitchRow('Certificate of Participation', _certificateOfParticipation,
                                  (v) => setState(() => _certificateOfParticipation = v)),
                              const Divider(color: AppColors.borderLight, height: 16),
                              _buildSwitchRow(
                                  'Send Email Reminders', _sendEmailReminders, (v) => setState(() => _sendEmailReminders = v)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Bottom action bar
              if (_isViewMode)
                BlocBuilder<EventsBloc, EventsState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        TextButton(
                          onPressed: widget.onBackToEvents,
                          child: const Text('Cancel',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: state.isUpdating ? null : _update,
                          icon: state.isUpdating
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.save_outlined, size: 14, color: Colors.white),
                          label: Text(
                            state.isUpdating ? 'Saving...' : 'Save Changes',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    );
                  },
                )
              else
                BlocBuilder<EventsBloc, EventsState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Text('All changes are automatically saved to draft.',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                        const Spacer(),
                        TextButton(
                          onPressed: widget.onBackToEvents,
                          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: state.isCreating ? null : _publish,
                          icon: state.isCreating
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.rocket_launch_outlined, size: 14, color: Colors.white),
                          label: Text(
                            state.isCreating ? 'Publishing...' : 'Publish Event',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF2).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _eventTypeLabels.length,
          (i) => _buildTypeButton(i, _eventTypeIcons[i], _eventTypeLabels[i]),
        ),
      ),
    );
  }

  Widget _buildTypeButton(int index, IconData icon, String label) {
    final bool isSelected = _activeEventTypeIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeEventTypeIndex = index),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textDark.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        SizedBox(
          height: 24,
          child: Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
        ),
      ],
    );
  }
}

// =========================================================================
// Speaker Selection Dialog
// =========================================================================

class _SpeakerSelectionDialog extends StatefulWidget {
  final List<Practioners> available;
  final List<Practioners> initialSelected;

  const _SpeakerSelectionDialog({required this.available, required this.initialSelected});

  @override
  State<_SpeakerSelectionDialog> createState() => _SpeakerSelectionDialogState();
}

class _SpeakerSelectionDialogState extends State<_SpeakerSelectionDialog> {
  final _searchController = TextEditingController();
  late final List<Practioners> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelected(Practioners p) => _selected.any((s) => s.id == p.id);

  void _toggle(Practioners p) {
    setState(() {
      if (_isSelected(p)) {
        _selected.removeWhere((s) => s.id == p.id);
      } else {
        _selected.add(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.available.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return (p.fullName ?? '').toLowerCase().contains(q) ||
          (p.qualifications ?? '').toLowerCase().contains(q) ||
          (p.hospitalAffiliation ?? '').toLowerCase().contains(q);
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const Text('Select Speakers',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const Spacer(),
                  if (_selected.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text('${_selected.length} selected',
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search by name or specialty...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, size: 16, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.scaffoldBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(height: 8),

            const Divider(color: AppColors.borderLight, height: 1),

            // List
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No verified practitioners found',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        final selected = _isSelected(p);
                        return InkWell(
                          onTap: () => _toggle(p),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                AppNetworkImage(
                                  imageUrl: '${p.photoUrl ?? p.photoPath}',
                                  width: 38,
                                  height: 38,
                                  isCircle: true,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.fullName ?? '—',
                                          style: const TextStyle(
                                              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                      Text(p.qualifications ?? p.hospitalAffiliation ?? '—',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: selected ? AppColors.primary : AppColors.borderLight,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const Divider(color: AppColors.borderLight, height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Shared Form Card Widget
// =========================================================================

class _FormBlockCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailingAction;

  const _FormBlockCard({required this.title, required this.icon, required this.child, this.trailingAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              Icon(icon, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              if (trailingAction != null) ...[const Spacer(), trailingAction!],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

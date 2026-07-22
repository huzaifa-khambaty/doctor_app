import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/data/models/requests/create_content_request.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_bloc.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_event.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_state.dart';

const _kContentTypes = ['PDF', 'Article', 'Webinar', 'Quiz'];
const _kStatuses = ['draft', 'review', 'published'];

class AddContentView extends StatefulWidget {
  final VoidCallback onBack;
  final Data? existingContent;

  const AddContentView({
    super.key,
    required this.onBack,
    this.existingContent,
  });

  @override
  State<AddContentView> createState() => _AddContentViewState();
}

class _AddContentViewState extends State<AddContentView> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEdit => widget.existingContent != null;

  // ── Form field controllers ───────────────────────────────────────────────
  late final TextEditingController _titleCtrl;
  late final _RichTextController _descriptionCtrl;

  // ── Selection state ──────────────────────────────────────────────────────
  String _contentType = _kContentTypes.first;
  String _status = 'draft';
  DateTime? _scheduledAt;
  Set<int> _selectedSpecialtyIds = {};
  int? _selectedQuizId;

  // ── External links ───────────────────────────────────────────────────────
  final List<TextEditingController> _externalLinkCtrls = [];

  // ── File state ───────────────────────────────────────────────────────────
  Uint8List? _fileBytes;
  String? _fileName;
  String? _existingFileUrl;

  // ── Thumbnail state ──────────────────────────────────────────────────────
  Uint8List? _thumbnailBytes;
  String? _thumbnailName;
  String? _existingThumbnailUrl;

  @override
  void initState() {
    super.initState();
    final c = widget.existingContent;
    _titleCtrl = TextEditingController(text: c?.title ?? '');
    _descriptionCtrl = _RichTextController(c?.description ?? '');
    if (c != null) {
      const typeMap = {1: 'PDF', 2: 'Article', 3: 'Webinar', 4: 'Quiz'};
      _contentType = typeMap[c.typeId] ?? _kContentTypes.first;
      _status = c.status ?? 'draft';
      _existingFileUrl = c.pdfUrl;
      _existingThumbnailUrl = c.thumbnailUrl;
      _selectedSpecialtyIds = c.specialties?.map((s) => s.id).whereType<int>().toSet() ?? {};
      _selectedQuizId = c.quizId;
      if (c.scheduledAt != null) {
        _scheduledAt = DateTime.tryParse(c.scheduledAt!);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ContentBloc>();
      bloc.add(FetchContentSpecialtiesRequested());
      bloc.add(FetchContentQuizzesRequested());
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    for (final c in _externalLinkCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get _requiresFile => _contentType == 'PDF' || _contentType == 'Webinar';

  void _pickFile() async {
    final allowed = _contentType == 'PDF'
        ? ['pdf']
        : ['mp4', 'mov', 'avi', 'mkv', 'webm'];
    final result = await FilePicker.platform.pickFiles(
      type: _contentType == 'PDF' ? FileType.custom : FileType.video,
      allowedExtensions: _contentType == 'PDF' ? allowed : null,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _fileBytes = file.bytes;
        _fileName = file.name;
      });
    }
  }

  void _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _thumbnailBytes = file.bytes;
        _thumbnailName = file.name;
      });
    }
  }

  void _addExternalLink() {
    setState(() => _externalLinkCtrls.add(TextEditingController()));
  }

  void _removeExternalLink(int index) {
    _externalLinkCtrls[index].dispose();
    setState(() => _externalLinkCtrls.removeAt(index));
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime.now()),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit(String targetStatus) {
    if (_descriptionCtrl.text.trim().isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Description is required', isError: true);
      return;
    }
    if (_selectedSpecialtyIds.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Please select at least one specialty', isError: true);
      return;
    }
    if ((_contentType == 'Article' || _contentType == 'Webinar') && _thumbnailBytes == null && (_existingThumbnailUrl == null || _existingThumbnailUrl!.isEmpty)) {
      SnackbarUtil.showSnackbar(context, message: 'Please upload a thumbnail image', isError: true);
      return;
    }
    if (_requiresFile && _fileBytes == null && (_existingFileUrl == null || _existingFileUrl!.isEmpty)) {
      SnackbarUtil.showSnackbar(
        context,
        message: 'Please upload a ${_contentType == 'PDF' ? 'PDF' : 'video'} file',
        isError: true,
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final externalLinks = _externalLinkCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final request = CreateContentRequest(
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.toHtml(),
      contentType: _contentType.toLowerCase(),
      link: null,
      externalLinks: externalLinks.isEmpty ? null : externalLinks,
      specialtyIds: _selectedSpecialtyIds.isEmpty ? null : _selectedSpecialtyIds.toList(),
      quizId: _selectedQuizId,
      scheduledAt: _scheduledAt?.toUtc().toIso8601String(),
      status: targetStatus,
      fileBytes: _fileBytes != null ? List<int>.from(_fileBytes!) : null,
      fileName: _fileName,
      thumbnailBytes: _thumbnailBytes != null ? List<int>.from(_thumbnailBytes!) : null,
      thumbnailName: _thumbnailName,
    );

    if (_isEdit) {
      context.read<ContentBloc>().add(
        UpdateContentRequested(
          contentId: widget.existingContent!.id!,
          request: UpdateContentRequest(
            title: request.title,
            description: request.description,
            contentType: request.contentType,
            link: request.link,
            externalLinks: request.externalLinks,
            specialtyIds: request.specialtyIds,
            quizId: request.quizId,
            scheduledAt: request.scheduledAt,
            status: targetStatus,
            fileBytes: request.fileBytes,
            fileName: request.fileName,
            thumbnailBytes: request.thumbnailBytes,
            thumbnailName: request.thumbnailName,
          ),
        ),
      );
    } else {
      context.read<ContentBloc>().add(CreateContentRequested(request));
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContentBloc, ContentState>(
      listenWhen: (prev, curr) =>
          (prev.submitSuccess != curr.submitSuccess && curr.submitSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.submitSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: _isEdit ? 'Content updated successfully' : 'Content created successfully',
          );
          widget.onBack();
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(state),
                  const SizedBox(height: 28),
                  _buildBasicInfoCard(),
                  const SizedBox(height: 20),
                  _buildMediaCard(),
                  const SizedBox(height: 20),
                  _buildClassificationCard(state),
                  const SizedBox(height: 20),
                  _buildPublishingCard(),
                  const SizedBox(height: 32),
                  _buildFooterActions(state),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(ContentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back navigation
        GestureDetector(
          onTap: widget.onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Content Repository',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
              ),
              Text(
                _isEdit ? 'Edit Content' : 'Add Content',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              _isEdit ? 'Edit Content' : 'Add Content',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const Spacer(),
            // Workflow status badge
            _StatusBadge(status: _status),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _isEdit
              ? 'Update the details for this content item.'
              : 'Create scientific content, upload media, and publish to the platform.',
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
  }

  // ── Basic Info Card ──────────────────────────────────────────────────────

  Widget _buildBasicInfoCard() {
    return _FormCard(
      icon: Icons.article_outlined,
      title: 'Basic Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Type
          _Label('Content Type'),
          const SizedBox(height: 8),
          Row(
            children: _kContentTypes.map((type) {
              final selected = _contentType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _contentType = type;
                    _fileBytes = null;
                    _fileName = null;
                    _thumbnailBytes = null;
                    _thumbnailName = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.borderLight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _typeIcon(type),
                          size: 14,
                          color: selected ? Colors.white : AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Title
          _Label('Title *'),
          const SizedBox(height: 8),
          _StyledTextField(
            controller: _titleCtrl,
            hintText: 'Enter content title',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
          ),
          const SizedBox(height: 20),

          // Description
          _Label('Description *'),
          const SizedBox(height: 8),
          _RichTextEditorField(controller: _descriptionCtrl),
        ],
      ),
    );
  }

  // ── Media Card ───────────────────────────────────────────────────────────

  Widget _buildMediaCard() {
    return _FormCard(
      icon: Icons.attach_file_outlined,
      title: 'Media & Links',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail / banner image — Article and Webinar only
          if (_contentType == 'Article' || _contentType == 'Webinar') ...[
            const _Label('Thumbnail / Banner Image *'),
            const SizedBox(height: 8),
            _buildThumbnailZone(),
            const SizedBox(height: 20),
          ],

          // File upload — PDF and Webinar only
          if (_requiresFile) ...[
            _Label(_contentType == 'PDF' ? 'Upload PDF File *' : 'Upload Video File *'),
            const SizedBox(height: 8),
            _buildFileZone(),
            const SizedBox(height: 20),
          ],

          // External links — Article and Webinar only
          if (_contentType == 'Article' || _contentType == 'Webinar') ...[
            Row(
              children: [
                const _Label('External Links'),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addExternalLink,
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('Add Link', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            if (_externalLinkCtrls.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No external links added yet.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.6)),
                ),
              )
            else
              ...List.generate(_externalLinkCtrls.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StyledTextField(
                          controller: _externalLinkCtrls[i],
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _removeExternalLink(i),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.remove, size: 16, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ],
      ),
    );
  }

  Widget _buildFileZone() {
    final hasFile = _fileBytes != null;
    final hasExisting = _existingFileUrl != null && _existingFileUrl!.isNotEmpty;

    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: hasFile
              ? AppColors.primary.withValues(alpha: 0.04)
              : const Color(0xFFF8FAFC),
          border: Border.all(
            color: hasFile ? AppColors.primary.withValues(alpha: 0.4) : AppColors.borderLight,
            style: hasFile ? BorderStyle.solid : BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              hasFile ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
              size: 32,
              color: hasFile ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 10),
            if (hasFile) ...[
              Text(
                _fileName ?? 'File selected',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to change file',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.7)),
              ),
            ] else if (hasExisting) ...[
              Text(
                'Current: ${_existingFileUrl!.split('/').last}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap to replace file',
                style: TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ] else ...[
              Text(
                _contentType == 'PDF' ? 'Click to upload PDF' : 'Click to upload video',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _contentType == 'PDF'
                    ? 'Supported format: PDF'
                    : 'Supported formats: MP4, MOV, AVI, MKV',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.7)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailZone() {
    final hasNew = _thumbnailBytes != null;
    final hasExisting = _existingThumbnailUrl != null && _existingThumbnailUrl!.isNotEmpty;

    return GestureDetector(
      onTap: _pickThumbnail,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: hasNew
              ? AppColors.primary.withValues(alpha: 0.04)
              : const Color(0xFFF8FAFC),
          border: Border.all(
            color: hasNew ? AppColors.primary.withValues(alpha: 0.4) : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              hasNew ? Icons.check_circle_outline : Icons.image_outlined,
              size: 32,
              color: hasNew ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 10),
            if (hasNew) ...[
              Text(
                _thumbnailName ?? 'Image selected',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to change image',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.7)),
              ),
            ] else if (hasExisting) ...[
              Text(
                'Current: ${_existingThumbnailUrl!.split('/').last}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap to replace image',
                style: TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ] else ...[
              const Text(
                'Click to upload thumbnail',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Supported formats: JPG, PNG, GIF, WEBP',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.7)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Classification Card ──────────────────────────────────────────────────

  Widget _buildClassificationCard(ContentState state) {
    return _FormCard(
      icon: Icons.label_outline,
      title: 'Classification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specialties multi-select
          Row(
            children: [
              const _Label('Specialties / Topics *'),
              const SizedBox(width: 6),
              Text(
                '(${_selectedSpecialtyIds.length} selected)',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSpecialtiesSelector(state),
          const SizedBox(height: 20),

          // Quiz link (only shown when content type is Quiz)
          if (_contentType == 'Quiz') ...[
            _Label('Link a Quiz'),
            const SizedBox(height: 8),
            _buildQuizDropdown(state),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSelector(ContentState state) {
    if (state.isLoadingSpecialties) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          6,
          (_) => Container(
            width: 90,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    if (state.specialties.isEmpty) {
      return Text(
        'No specialties available.',
        style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.7)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.specialties.map((s) {
        final selected = s.id != null && _selectedSpecialtyIds.contains(s.id);
        return GestureDetector(
          onTap: () {
            if (s.id == null) return;
            setState(() {
              if (selected) {
                _selectedSpecialtyIds.remove(s.id);
              } else {
                _selectedSpecialtyIds.add(s.id!);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.white,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderLight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                ],
                Text(
                  s.name ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizDropdown(ContentState state) {
    if (state.isLoadingQuizzes) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    final items = <DropdownMenuItem<int?>>[
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('None', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
      ),
      ...state.quizzes.map(
        (q) => DropdownMenuItem<int?>(
          value: q.id,
          child: Text(q.title ?? 'Quiz #${q.id}', style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
        ),
      ),
    ];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: _selectedQuizId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          onChanged: (v) => setState(() => _selectedQuizId = v),
          items: items,
        ),
      ),
    );
  }

  // ── Publishing Card ──────────────────────────────────────────────────────

  Widget _buildPublishingCard() {
    return _FormCard(
      icon: Icons.publish_outlined,
      title: 'Publishing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status workflow
          const _Label('Workflow Status'),
          const SizedBox(height: 10),
          Row(
            children: _kStatuses.map((s) {
              final selected = _status == s;
              final color = _statusColor(s);
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? color.withValues(alpha: 0.1) : Colors.white,
                      border: Border.all(
                        color: selected ? color : AppColors.borderLight,
                        width: selected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fiber_manual_record, size: 8, color: selected ? color : AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          _statusLabel(s),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                            color: selected ? color : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          Text(
            'Draft → Review → Published',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 20),

          // Schedule
          const _Label('Schedule Publication (optional)'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickSchedule,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _scheduledAt != null
                          ? DateFormat('MMM d, yyyy • h:mm a').format(_scheduledAt!.toLocal())
                          : 'Pick a date & time',
                      style: TextStyle(
                        fontSize: 13,
                        color: _scheduledAt != null ? AppColors.textDark : AppColors.textMuted,
                      ),
                    ),
                  ),
                  if (_scheduledAt != null)
                    GestureDetector(
                      onTap: () => setState(() => _scheduledAt = null),
                      child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer Actions ───────────────────────────────────────────────────────

  Widget _buildFooterActions(ContentState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: state.isSubmitting ? null : widget.onBack,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.borderLight),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: state.isSubmitting ? null : () => _submit('draft'),
          icon: const Icon(Icons.save_outlined, size: 16),
          label: const Text('Save as Draft', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: state.isSubmitting ? null : () => _submit('published'),
          icon: state.isSubmitting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.rocket_launch_outlined, size: 16, color: Colors.white),
          label: Text(
            _isEdit ? 'Update & Publish' : 'Publish',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005B5C),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  IconData _typeIcon(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf_outlined;
      case 'Article':
        return Icons.article_outlined;
      case 'Webinar':
        return Icons.video_library_outlined;
      case 'Quiz':
        return Icons.quiz_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'published':
        return AppColors.successGreen;
      case 'review':
        return AppColors.warningOrange;
      default:
        return AppColors.textMuted;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'published':
        return 'Published';
      case 'review':
        return 'In Review';
      default:
        return 'Draft';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _FormCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(color: AppColors.borderLight, height: 20),
          child,
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// WYSIWYG rich-text controller + editor
// ─────────────────────────────────────────────────────────────────────────────

enum _Fmt { bold, italic, underline, h1, h2, h3 }

class _FormatRange {
  int start;
  int end;
  final _Fmt fmt;
  _FormatRange(this.start, this.end, this.fmt);
}

class _RichTextController extends TextEditingController {
  final List<_FormatRange> _formats = [];
  String _prev = '';

  _RichTextController([String raw = '']) : super(text: _extractPlain(raw)) {
    _formats.addAll(_extractFormats(raw));
    _prev = text;
    addListener(_sync);
  }

  // ── HTML → plain text + format ranges ────────────────────────────────────

  static const _kTagMap = {
    'h1': _Fmt.h1, 'h2': _Fmt.h2, 'h3': _Fmt.h3,
    'strong': _Fmt.bold, 'b': _Fmt.bold,
    'em': _Fmt.italic, 'i': _Fmt.italic,
    'u': _Fmt.underline,
  };

  static bool _isHtml(String s) => s.contains('<') && s.contains('>');

  static String _extractPlain(String raw) =>
      _isHtml(raw) ? _parseHtml(raw).$1 : raw;

  static List<_FormatRange> _extractFormats(String raw) =>
      _isHtml(raw) ? _parseHtml(raw).$2 : [];

  static (String, List<_FormatRange>) _parseHtml(String html) {
    final buf = StringBuffer();
    final ranges = <_FormatRange>[];
    final stack = <(int, _Fmt)>[];
    int i = 0;
    while (i < html.length) {
      if (html[i] == '<') {
        final end = html.indexOf('>', i);
        if (end == -1) { buf.write(html[i]); i++; continue; }
        final tag = html.substring(i + 1, end).trim().toLowerCase();
        if (tag.startsWith('/')) {
          final name = tag.substring(1).trim();
          final fmt = _kTagMap[name];
          if (fmt != null) {
            for (int j = stack.length - 1; j >= 0; j--) {
              if (stack[j].$2 == fmt) {
                final start = stack[j].$1;
                if (buf.length > start) {
                  ranges.add(_FormatRange(start, buf.length, fmt));
                }
                stack.removeAt(j);
                break;
              }
            }
          }
        } else {
          final name = tag.split(RegExp(r'[\s>]'))[0];
          final fmt = _kTagMap[name];
          if (fmt != null) stack.add((buf.length, fmt));
        }
        i = end + 1;
      } else if (html[i] == '&') {
        final semi = html.indexOf(';', i);
        if (semi != -1 && semi - i <= 6) {
          final entity = html.substring(i + 1, semi);
          buf.write(switch (entity) {
            'amp'  => '&',
            'lt'   => '<',
            'gt'   => '>',
            'nbsp' => ' ',
            'quot' => '"',
            _      => '&$entity;',
          });
          i = semi + 1;
        } else {
          buf.write(html[i]);
          i++;
        }
      } else {
        buf.write(html[i]);
        i++;
      }
    }
    return (buf.toString(), ranges);
  }

  // ── Keep format spans in sync when text is edited ─────────────────────────
  void _sync() {
    final curr = text;
    if (curr == _prev) { _prev = curr; return; }
    _adjustSpans(_prev, curr);
    _prev = curr;
  }

  void _adjustSpans(String old, String curr) {
    int pfx = 0;
    final min = old.length < curr.length ? old.length : curr.length;
    while (pfx < min && old[pfx] == curr[pfx]) { pfx++; }

    int sfx = 0;
    while (sfx < old.length - pfx &&
           sfx < curr.length - pfx &&
           old[old.length - 1 - sfx] == curr[curr.length - 1 - sfx]) {
      sfx++;
    }

    final delEnd = old.length - sfx;
    final insEnd = curr.length - sfx;
    final delta  = insEnd - delEnd;

    for (final f in _formats) {
      if (delta > 0) {
        if (f.start >= delEnd) { f.start += delta; }
        else if (f.start > pfx) { f.start = insEnd; }
        if (f.end >= delEnd) { f.end += delta; }
        else if (f.end > pfx) { f.end = insEnd; }
      } else if (delta < 0) {
        if (f.start >= delEnd) { f.start += delta; }
        else if (f.start > pfx) { f.start = pfx; }
        if (f.end >= delEnd) { f.end += delta; }
        else if (f.end > pfx) { f.end = pfx; }
        f.start = f.start.clamp(0, curr.length);
        f.end   = f.end.clamp(0, curr.length);
      }
    }
    _formats.removeWhere((f) => f.start >= f.end);
  }

  // ── Apply / toggle a format on the current selection ─────────────────────
  void applyFormat(_Fmt fmt) {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) return;
    final s = sel.start, e = sel.end;
    final already = _formats.any((f) => f.fmt == fmt && f.start <= s && f.end >= e);
    _formats.removeWhere((f) => f.fmt == fmt && f.start < e && f.end > s);
    if (!already) _formats.add(_FormatRange(s, e, fmt));
    notifyListeners();
  }

  bool isActive(_Fmt fmt) {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) return false;
    return _formats.any((f) => f.fmt == fmt && f.start <= sel.start && f.end >= sel.end);
  }

  // ── Serialize to HTML for API submission ──────────────────────────────────
  String toHtml() {
    final plain = text;
    if (_formats.isEmpty) return plain;
    final charFmts = List<Set<_Fmt>>.generate(plain.length, (_) => {});
    for (final f in _formats) {
      for (int i = f.start.clamp(0, plain.length); i < f.end.clamp(0, plain.length); i++) {
        charFmts[i].add(f.fmt);
      }
    }
    final buf = StringBuffer();
    int i = 0;
    while (i < plain.length) {
      final fmts = charFmts[i];
      int j = i + 1;
      while (j < plain.length && _eq(charFmts[j], fmts)) { j++; }
      buf.write(_openTags(fmts));
      buf.write(plain.substring(i, j));
      buf.write(_closeTags(fmts));
      i = j;
    }
    return buf.toString();
  }

  String _openTags(Set<_Fmt> f) {
    final b = StringBuffer();
    if (f.contains(_Fmt.h1))        b.write('<h1>');
    if (f.contains(_Fmt.h2))        b.write('<h2>');
    if (f.contains(_Fmt.h3))        b.write('<h3>');
    if (f.contains(_Fmt.bold))      b.write('<strong>');
    if (f.contains(_Fmt.italic))    b.write('<em>');
    if (f.contains(_Fmt.underline)) b.write('<u>');
    return b.toString();
  }

  String _closeTags(Set<_Fmt> f) {
    final b = StringBuffer();
    if (f.contains(_Fmt.underline)) b.write('</u>');
    if (f.contains(_Fmt.italic))    b.write('</em>');
    if (f.contains(_Fmt.bold))      b.write('</strong>');
    if (f.contains(_Fmt.h3))        b.write('</h3>');
    if (f.contains(_Fmt.h2))        b.write('</h2>');
    if (f.contains(_Fmt.h1))        b.write('</h1>');
    return b.toString();
  }

  // ── Render formatted text inside the TextField ────────────────────────────
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final plain = text;
    if (_formats.isEmpty || plain.isEmpty) {
      return TextSpan(style: style, text: plain);
    }
    final charFmts = List<Set<_Fmt>>.generate(plain.length, (_) => {});
    for (final f in _formats) {
      for (int i = f.start.clamp(0, plain.length); i < f.end.clamp(0, plain.length); i++) {
        charFmts[i].add(f.fmt);
      }
    }
    final children = <TextSpan>[];
    int i = 0;
    while (i < plain.length) {
      final fmts = charFmts[i];
      int j = i + 1;
      while (j < plain.length && _eq(charFmts[j], fmts)) { j++; }
      children.add(TextSpan(text: plain.substring(i, j), style: _applyFmts(style, fmts)));
      i = j;
    }
    return TextSpan(style: style, children: children);
  }

  bool _eq(Set<_Fmt> a, Set<_Fmt> b) => a.length == b.length && a.containsAll(b);

  TextStyle _applyFmts(TextStyle? base, Set<_Fmt> fmts) {
    var s = base ?? const TextStyle();
    for (final f in fmts) {
      s = switch (f) {
        _Fmt.bold      => s.copyWith(fontWeight: FontWeight.bold),
        _Fmt.italic    => s.copyWith(fontStyle: FontStyle.italic),
        _Fmt.underline => s.copyWith(decoration: TextDecoration.underline),
        _Fmt.h1        => s.copyWith(fontSize: 22, fontWeight: FontWeight.bold, height: 1.4),
        _Fmt.h2        => s.copyWith(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
        _Fmt.h3        => s.copyWith(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
      };
    }
    return s;
  }

  @override
  void dispose() {
    removeListener(_sync);
    super.dispose();
  }
}

class _RichTextEditorField extends StatelessWidget {
  final _RichTextController controller;
  const _RichTextEditorField({required this.controller});

  void _apply(_Fmt fmt, void Function(VoidCallback) setState) {
    controller.applyFormat(fmt);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Toolbar ───────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListenableBuilder(
                listenable: controller,
                builder: (ctx, _) {
                  return StatefulBuilder(
                    builder: (ctx, setState) => Row(
                      children: [
                        _FmtBtn(label: 'H1', fmt: _Fmt.h1,        ctrl: controller, bold: true,      onTap: () => _apply(_Fmt.h1,        setState)),
                        _FmtBtn(label: 'H2', fmt: _Fmt.h2,        ctrl: controller, bold: true,      onTap: () => _apply(_Fmt.h2,        setState)),
                        _FmtBtn(label: 'H3', fmt: _Fmt.h3,        ctrl: controller, bold: true,      onTap: () => _apply(_Fmt.h3,        setState)),
                        _ToolbarSep(),
                        _FmtBtn(label: 'B',  fmt: _Fmt.bold,      ctrl: controller, bold: true,      onTap: () => _apply(_Fmt.bold,      setState)),
                        _FmtBtn(label: 'I',  fmt: _Fmt.italic,    ctrl: controller, italic: true,    onTap: () => _apply(_Fmt.italic,    setState)),
                        _FmtBtn(label: 'U',  fmt: _Fmt.underline, ctrl: controller, underline: true, onTap: () => _apply(_Fmt.underline, setState)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Editable area ─────────────────────────────────────────────────
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 12,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.6),
            decoration: InputDecoration(
              hintText: 'Enter description...',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFFCFDFE),
              contentPadding: const EdgeInsets.all(14),
              border: InputBorder.none,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          ListenableBuilder(
            listenable: controller,
            builder: (context, w) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  Text(
                    'Select text then tap a format button',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.6)),
                  ),
                  const Spacer(),
                  Text(
                    '${controller.text.length} chars',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FmtBtn extends StatelessWidget {
  final String label;
  final _Fmt fmt;
  final _RichTextController ctrl;
  final VoidCallback onTap;
  final bool bold;
  final bool italic;
  final bool underline;

  const _FmtBtn({
    required this.label,
    required this.fmt,
    required this.ctrl,
    required this.onTap,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    final active = ctrl.isActive(fmt);
    return Tooltip(
      message: fmt.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.only(right: 2),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: active ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: active ? Border.all(color: AppColors.primary.withValues(alpha: 0.4)) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration: underline ? TextDecoration.underline : null,
              color: active ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 20,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: AppColors.borderLight,
      );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case 'published':
        return AppColors.successGreen;
      case 'review':
        return AppColors.warningOrange;
      default:
        return AppColors.textMuted;
    }
  }

  String get _label {
    switch (status) {
      case 'published':
        return 'Published';
      case 'review':
        return 'In Review';
      default:
        return 'Draft';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: _color),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _color),
          ),
        ],
      ),
    );
  }
}

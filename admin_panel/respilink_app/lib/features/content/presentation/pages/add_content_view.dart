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
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _linkCtrl;

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
    _descriptionCtrl = TextEditingController(text: c?.description ?? '');
    _linkCtrl = TextEditingController(text: c?.contentLink ?? '');
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
    _linkCtrl.dispose();
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
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      contentType: _contentType.toLowerCase(),
      link: _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim(),
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
          _HtmlEditorField(controller: _descriptionCtrl),
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

          // Content link and external links — Article and Webinar only
          if (_contentType == 'Article' || _contentType == 'Webinar') ...[
            _Label(_contentType == 'Webinar' ? 'External Video Link' : 'Content Link *'),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: _linkCtrl,
              hintText: 'https://',
              keyboardType: TextInputType.url,
              validator: _contentType == 'Webinar'
                  ? (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final uri = Uri.tryParse(v.trim());
                      if (uri == null || !uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
                        return 'Enter a valid URL (https://...)';
                      }
                      return null;
                    }
                  : (v) {
                      if (v == null || v.trim().isEmpty) return 'Content link is required';
                      final uri = Uri.tryParse(v.trim());
                      if (uri == null || !uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
                        return 'Enter a valid URL (https://...)';
                      }
                      return null;
                    },
            ),
            const SizedBox(height: 20),
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
// HTML toolbar editor
// ─────────────────────────────────────────────────────────────────────────────

class _HtmlEditorField extends StatefulWidget {
  final TextEditingController controller;

  const _HtmlEditorField({required this.controller});

  @override
  State<_HtmlEditorField> createState() => _HtmlEditorFieldState();
}

class _HtmlEditorFieldState extends State<_HtmlEditorField> {
  bool _showPreview = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _wrap(String open, String close) {
    final ctrl = widget.controller;
    final sel = ctrl.selection;
    final text = ctrl.text;

    if (!sel.isValid) {
      // No cursor — append tags at the end
      final inserted = '$open$close';
      ctrl.value = TextEditingValue(
        text: text + inserted,
        selection: TextSelection.collapsed(offset: text.length + open.length),
      );
      return;
    }

    if (sel.isCollapsed) {
      // No selection — insert tag pair at cursor, place caret between them
      final before = text.substring(0, sel.start);
      final after = text.substring(sel.start);
      ctrl.value = TextEditingValue(
        text: '$before$open$close$after',
        selection: TextSelection.collapsed(offset: sel.start + open.length),
      );
    } else {
      // Wrap selected text
      final selected = sel.textInside(text);
      final before = text.substring(0, sel.start);
      final after = text.substring(sel.end);
      ctrl.value = TextEditingValue(
        text: '$before$open$selected$close$after',
        selection: TextSelection.collapsed(
          offset: sel.start + open.length + selected.length + close.length,
        ),
      );
    }
    _focusNode.requestFocus();
  }

  void _insertBlock(String open, String close, {String inner = ''}) {
    final ctrl = widget.controller;
    final sel = ctrl.selection;
    final text = ctrl.text;
    final pos = sel.isValid ? sel.start : text.length;
    final prefix = (pos > 0 && text[pos - 1] != '\n') ? '\n' : '';
    final snippet = '$prefix$open$inner$close\n';
    final newText = text.substring(0, pos) + snippet + text.substring(pos);
    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: pos + prefix.length + open.length),
    );
    _focusNode.requestFocus();
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
          // ── Toolbar ────────────────────────────────────────────────────────
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
              child: Row(
                children: [
                  // Headings
                  _ToolbarBtn(label: 'H1', tooltip: 'Heading 1', onTap: () => _wrap('<h1>', '</h1>')),
                  _ToolbarBtn(label: 'H2', tooltip: 'Heading 2', onTap: () => _wrap('<h2>', '</h2>')),
                  _ToolbarBtn(label: 'H3', tooltip: 'Heading 3', onTap: () => _wrap('<h3>', '</h3>')),
                  _ToolbarBtn(label: 'P',  tooltip: 'Paragraph',  onTap: () => _wrap('<p>', '</p>')),
                  const _ToolbarDivider(),

                  // Inline styles
                  _ToolbarBtn(label: 'B', tooltip: 'Bold',      bold: true,   onTap: () => _wrap('<strong>', '</strong>')),
                  _ToolbarBtn(label: 'I', tooltip: 'Italic',    italic: true, onTap: () => _wrap('<em>', '</em>')),
                  _ToolbarBtn(label: 'U', tooltip: 'Underline', underline: true, onTap: () => _wrap('<u>', '</u>')),
                  const _ToolbarDivider(),

                  // Lists
                  _ToolbarIconBtn(icon: Icons.format_list_bulleted, tooltip: 'Unordered list',
                      onTap: () => _insertBlock('<ul>\n  <li>', '</li>\n</ul>')),
                  _ToolbarIconBtn(icon: Icons.format_list_numbered, tooltip: 'Ordered list',
                      onTap: () => _insertBlock('<ol>\n  <li>', '</li>\n</ol>')),
                  _ToolbarBtn(label: 'LI', tooltip: 'List item', onTap: () => _wrap('<li>', '</li>')),
                  const _ToolbarDivider(),

                  // Other
                  _ToolbarIconBtn(icon: Icons.link, tooltip: 'Hyperlink',
                      onTap: () => _wrap('<a href="">', '</a>')),
                  _ToolbarIconBtn(icon: Icons.image_outlined, tooltip: 'Image',
                      onTap: () => _insertBlock('<img src="', '" alt="" />')),
                  _ToolbarBtn(label: 'BR', tooltip: 'Line break', onTap: () {
                    final ctrl = widget.controller;
                    final sel = ctrl.selection;
                    final text = ctrl.text;
                    final pos = sel.isValid ? sel.start : text.length;
                    final newText = '${text.substring(0, pos)}<br />\n${text.substring(pos)}';
                    ctrl.value = TextEditingValue(
                      text: newText,
                      selection: TextSelection.collapsed(offset: pos + 7),
                    );
                    _focusNode.requestFocus();
                  }),
                  const _ToolbarDivider(),

                  // Preview toggle
                  GestureDetector(
                    onTap: () => setState(() => _showPreview = !_showPreview),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _showPreview
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: _showPreview ? AppColors.primary : AppColors.borderLight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showPreview ? Icons.code : Icons.preview_outlined,
                            size: 14,
                            color: _showPreview ? AppColors.primary : AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showPreview ? 'HTML' : 'Preview',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _showPreview ? AppColors.primary : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Editor / Preview ──────────────────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showPreview ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              minLines: 10,
              maxLines: 20,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
                fontFamily: 'monospace',
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: '<h2>Section Heading</h2>\n<p>Your content here...</p>',
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withValues(alpha: 0.4),
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
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
            secondChild: _HtmlPreview(html: widget.controller.text),
          ),

          // ── Footer hint ───────────────────────────────────────────────────
          if (!_showPreview)
            ListenableBuilder(
              listenable: widget.controller,
              builder: (_, child) {
                final charCount = widget.controller.text.length;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.borderLight)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Use toolbar to insert HTML tags, or type directly',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.6)),
                      ),
                      const Spacer(),
                      Text(
                        '$charCount chars',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Renders a styled preview of raw HTML tags without a WebView
class _HtmlPreview extends StatelessWidget {
  final String html;
  const _HtmlPreview({required this.html});

  @override
  Widget build(BuildContext context) {
    final lines = html.split('\n');
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: html.trim().isEmpty
          ? Text(
              'Nothing to preview yet.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted.withValues(alpha: 0.5)),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) => _renderLine(line.trim())).toList(),
            ),
    );
  }

  Widget _renderLine(String line) {
    if (line.isEmpty) return const SizedBox(height: 4);

    if (line.startsWith('<h1>') && line.endsWith('</h1>')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(_stripTags(line),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      );
    }
    if (line.startsWith('<h2>') && line.endsWith('</h2>')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 4),
        child: Text(_stripTags(line),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      );
    }
    if (line.startsWith('<h3>') && line.endsWith('</h3>')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        child: Text(_stripTags(line),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      );
    }
    if (line.startsWith('<p>') && line.endsWith('</p>')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(_stripTags(line),
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.6)),
      );
    }
    if (line.startsWith('<li>') && line.endsWith('</li>')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
            Expanded(child: Text(_stripTags(line),
                style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.5))),
          ],
        ),
      );
    }
    if (line == '<br />' || line == '<br/>') {
      return const SizedBox(height: 10);
    }
    // Raw HTML fallback — show in muted monospace
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        line,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'monospace'),
      ),
    );
  }

  String _stripTags(String s) => s.replaceAll(RegExp(r'<[^>]+>'), '');
}

class _ToolbarBtn extends StatelessWidget {
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final bool bold;
  final bool italic;
  final bool underline;

  const _ToolbarBtn({
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.only(right: 2),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration: underline ? TextDecoration.underline : null,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ToolbarIconBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.only(right: 2),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 16, color: AppColors.textDark),
        ),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  const _ToolbarDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppColors.borderLight,
    );
  }
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

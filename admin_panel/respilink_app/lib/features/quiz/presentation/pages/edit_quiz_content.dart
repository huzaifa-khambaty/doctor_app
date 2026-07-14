import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_detail_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/data/models/requests/add_questions_request.dart';
import 'package:respilink_app/features/quiz/data/models/requests/create_quiz_request.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:respilink_app/service/image_picker_service.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Draft models
// ─────────────────────────────────────────────────────────────────────────────

class _OptionDraft {
  final TextEditingController textController;
  final TextEditingController explanationController;
  bool isCorrect;

  _OptionDraft()
      : isCorrect = false,
        textController = TextEditingController(),
        explanationController = TextEditingController();

  _OptionDraft.fromDetail(Options o)
      : textController = TextEditingController(text: o.optionText ?? ''),
        explanationController = TextEditingController(text: o.explanation ?? ''),
        isCorrect = o.isCorrect ?? false;

  void dispose() {
    textController.dispose();
    explanationController.dispose();
  }
}

class _QuestionDraft {
  final int? existingId; // server-side question ID, required on update
  final TextEditingController questionController;
  bool isMultiple;
  final List<_OptionDraft> options;
  PickedImage? newImage;
  Uint8List? imagePreviewBytes;
  String? existingImageUrl;
  String? existingImagePath;

  _QuestionDraft()
      : existingId = null,
        questionController = TextEditingController(),
        isMultiple = false,
        options = List.generate(4, (_) => _OptionDraft());

  _QuestionDraft.fromDetail(Questions q)
      : existingId = q.id,
        questionController = TextEditingController(text: q.questionText ?? ''),
        isMultiple = q.isMultiple ?? false,
        existingImagePath = q.imagePath,
        existingImageUrl =
            q.imagePath != null ? '${ApiEndpoints.imageUrl}${q.imagePath}' : null,
        options = (q.options ?? []).map((o) => _OptionDraft.fromDetail(o)).toList();

  void dispose() {
    questionController.dispose();
    for (final o in options) {
      o.dispose();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class EditQuizContent extends StatefulWidget {
  final int quizId;
  final VoidCallback onBackToQuizDirectory;

  const EditQuizContent({
    super.key,
    required this.quizId,
    required this.onBackToQuizDirectory,
  });

  @override
  State<EditQuizContent> createState() => _EditQuizContentState();
}

class _EditQuizContentState extends State<EditQuizContent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _opensAtController = TextEditingController();
  final _closesAtController = TextEditingController();
  final _timeLimitController = TextEditingController();
  QuizTopicModel? _selectedTopic;
  int? _pendingTopicId; // saved topicId for matching when topics load late
  final List<_QuestionDraft> _questions = [];
  bool _populated = false;

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(ResetQuizFormRequested());
    context.read<QuizBloc>().add(FetchTopicsRequested());
    context.read<QuizBloc>().add(FetchQuizDetailRequested(widget.quizId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _opensAtController.dispose();
    _closesAtController.dispose();
    _timeLimitController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _populate(QuizDetailModel detail, List<QuizTopicModel> topics) {
    if (_populated) return;
    _populated = true;
    _pendingTopicId = detail.topicId;
    setState(() {
      _titleController.text = detail.title ?? '';
      _descriptionController.text = detail.description ?? '';
      _opensAtController.text = detail.opensAt ?? '';
      _closesAtController.text = detail.closesAt ?? '';
      _timeLimitController.text = detail.timeLimitMinutes?.toString() ?? '';

      _tryMatchTopic(topics);

      for (final q in _questions) {
        q.dispose();
      }
      _questions.clear();

      final qs = detail.questions ?? [];
      if (qs.isEmpty) {
        _questions.add(_QuestionDraft());
      } else {
        _questions.addAll(qs.map((q) => _QuestionDraft.fromDetail(q)));
      }
    });
  }

  void _tryMatchTopic(List<QuizTopicModel> topics) {
    final id = _pendingTopicId ?? _selectedTopic?.id;
    if (id == null || topics.isEmpty) return;
    try {
      _selectedTopic = topics.firstWhere((t) => t.id == id);
    } catch (_) {
      _selectedTopic = null;
    }
  }

  // ── Date picker ────────────────────────────────────────────────────────────

  Future<void> _pickDateTime(TextEditingController target) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx)
            .copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx)
            .copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (!mounted) return;

    final dt = DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
    target.text =
        '${dt.year}-${_p(dt.month)}-${_p(dt.day)} ${_p(dt.hour)}:${_p(dt.minute)}:00';
  }

  String _p(int n) => n.toString().padLeft(2, '0');

  // ── Question helpers ───────────────────────────────────────────────────────

  Future<void> _pickImage(int qi) async {
    final result = await ImagePickerService.instance.pickFromGallery();
    if (!mounted) return;
    if (result.isSuccess && result.image != null) {
      setState(() {
        _questions[qi].newImage = result.image;
        _questions[qi].imagePreviewBytes = result.image!.bytes;
        _questions[qi].existingImageUrl = null;
        _questions[qi].existingImagePath = null;
      });
    }
  }

  void _clearImage(int qi) {
    setState(() {
      _questions[qi].newImage = null;
      _questions[qi].imagePreviewBytes = null;
      _questions[qi].existingImageUrl = null;
      _questions[qi].existingImagePath = null;
    });
  }

  void _addQuestion() => setState(() => _questions.add(_QuestionDraft()));

  void _removeQuestion(int i) {
    setState(() {
      _questions[i].dispose();
      _questions.removeAt(i);
    });
  }

  void _addOption(int qi) => setState(() => _questions[qi].options.add(_OptionDraft()));

  void _removeOption(int qi, int oi) {
    if (_questions[qi].options.length <= 2) return;
    setState(() {
      _questions[qi].options[oi].dispose();
      _questions[qi].options.removeAt(oi);
    });
  }

  void _setCorrect(int qi, int oi, bool value) {
    setState(() {
      final q = _questions[qi];
      if (!q.isMultiple) {
        for (int i = 0; i < q.options.length; i++) {
          q.options[i].isCorrect = i == oi;
        }
      } else {
        q.options[oi].isCorrect = value;
      }
    });
  }

  // ── Validate & submit ──────────────────────────────────────────────────────

  String? _validate() {
    if (_titleController.text.trim().isEmpty) return 'Quiz title is required.';
    if (_questions.isEmpty) return 'Add at least one question.';
    for (int qi = 0; qi < _questions.length; qi++) {
      final q = _questions[qi];
      if (q.questionController.text.trim().isEmpty) return 'Question ${qi + 1} text is required.';
      if (q.options.length < 2) return 'Question ${qi + 1} needs at least 2 options.';
      for (int oi = 0; oi < q.options.length; oi++) {
        if (q.options[oi].textController.text.trim().isEmpty) {
          return 'Question ${qi + 1}, option ${oi + 1} text is required.';
        }
      }
      if (!q.options.any((o) => o.isCorrect)) {
        return 'Question ${qi + 1} needs at least one correct answer.';
      }
    }
    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      SnackbarUtil.showSnackbar(context, message: error, isError: true);
      return;
    }

    final updateRequest = CreateQuizRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      opensAt: _opensAtController.text.isEmpty ? null : _opensAtController.text,
      closesAt: _closesAtController.text.isEmpty ? null : _closesAtController.text,
      timeLimitMinutes: int.tryParse(_timeLimitController.text.trim()),
      topic: _selectedTopic?.id,
    );

    final questionRequests = List.generate(_questions.length, (qi) {
      final q = _questions[qi];
      return QuestionRequest(
        id: q.existingId,
        questionText: q.questionController.text.trim(),
        imageBytes: q.newImage?.bytes,
        imageName: q.newImage?.name,
        existingImagePath: q.existingImagePath,
        isMultiple: q.isMultiple,
        order: qi + 1,
        options: List.generate(q.options.length, (oi) {
          final o = q.options[oi];
          return OptionRequest(
            optionText: o.textController.text.trim(),
            isCorrect: o.isCorrect,
            explanation: o.explanationController.text.trim().isEmpty
                ? null
                : o.explanationController.text.trim(),
            order: oi,
          );
        }),
      );
    });

    if (!mounted) return;
    context.read<QuizBloc>().add(UpdateQuizRequested(
          quizId: widget.quizId,
          updateRequest: updateRequest,
          questionsRequest: AddQuestionsRequest(questionRequests),
        ));
  }

  // ── Input decoration ───────────────────────────────────────────────────────

  InputDecoration _inputDeco(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF5F8FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        suffixIcon: suffix,
      );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.of(context).size.width >= 1100;

    return BlocListener<QuizBloc, QuizState>(
      listenWhen: (prev, curr) =>
          (prev.quizDetail != curr.quizDetail && curr.quizDetail != null) ||
          (prev.topics != curr.topics && curr.topics.isNotEmpty) ||
          (prev.submitSuccess != curr.submitSuccess && curr.submitSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (!_populated && state.quizDetail != null) {
          _populate(state.quizDetail!, state.topics);
        } else if (_populated && state.topics.isNotEmpty) {
          setState(() => _tryMatchTopic(state.topics));
        }
        if (state.submitSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Quiz updated successfully');
          context.read<QuizBloc>().add(FetchQuizzesRequested());
          widget.onBackToQuizDirectory();
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              // Safety net: populate if detail is available but listener hasn't fired yet.
              if (!_populated && state.quizDetail != null) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _populate(state.quizDetail!, state.topics));
              }

              final loading = state.isLoadingDetail || !_populated;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumbs
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onBackToQuizDirectory,
                            child: Text('Quizzes',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted.withValues(alpha: 0.8))),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text('/', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ),
                          const Text('Edit Quiz',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text('Edit Quiz',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      const Text('Update the clinical assessment details and questions.',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (loading)
                    _buildShimmer(wide)
                  else ...[
                    // Metadata row
                    _buildMetadataRow(wide, state),
                    const SizedBox(height: 32),

                    // Questions header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quiz Questions',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFF005B5C),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '${_questions.length} Question${_questions.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(
                      _questions.length,
                      (qi) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildQuestionCard(qi, wide),
                      ),
                    ),

                    // Add question
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight)),
                      child: InkWell(
                        onTap: _addQuestion,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle),
                                child: const Icon(Icons.add, size: 16, color: AppColors.primary),
                              ),
                              const SizedBox(height: 6),
                              const Text('Add Another Question',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed:
                              state.isSubmitting ? null : widget.onBackToQuizDirectory,
                          child: const Text('Discard Changes',
                              style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: state.isSubmitting ? null : _submit,
                          icon: state.isSubmitting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const SizedBox.shrink(),
                          label: const Text('Save Changes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(bool wide, QuizState state) {
    final generalCard = _SectionCard(
      title: 'General Information',
      icon: Icons.info_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('QUIZ TITLE'),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            decoration: _inputDeco('e.g., Advanced Respiratory Diagnostics'),
          ),
          const SizedBox(height: 16),
          _label('DESCRIPTION (OPTIONAL)'),
          const SizedBox(height: 6),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: _inputDeco('Explain what the clinician will learn...'),
          ),
        ],
      ),
    );

    final configCard = _SectionCard(
      title: 'Configuration',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('TOPIC AREA'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<QuizTopicModel>(
                value: _selectedTopic,
                isExpanded: true,
                hint: const Text('Select a topic',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                items: state.topics
                    .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.name ?? '', style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (v) => setState(() => _selectedTopic = v),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _label('TIME LIMIT (MINUTES)'),
          const SizedBox(height: 6),
          TextField(
            controller: _timeLimitController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDeco('e.g., 30'),
          ),
          const SizedBox(height: 16),
          _label('OPEN PERIOD'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _opensAtController,
                  readOnly: true,
                  onTap: () => _pickDateTime(_opensAtController),
                  decoration: _inputDeco('Start date',
                      suffix: const Icon(Icons.calendar_today_outlined,
                          size: 14, color: AppColors.textMuted)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('to', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
              Expanded(
                child: TextField(
                  controller: _closesAtController,
                  readOnly: true,
                  onTap: () => _pickDateTime(_closesAtController),
                  decoration: _inputDeco('End date',
                      suffix: const Icon(Icons.calendar_today_outlined,
                          size: 14, color: AppColors.textMuted)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: generalCard),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: configCard),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        generalCard,
        const SizedBox(height: 16),
        configCard,
      ],
    );
  }

  Widget _buildShimmer(bool wide) {
    final box200 = Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final topRow = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: box200),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: box200),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              box200,
              const SizedBox(height: 16),
              box200,
            ],
          );

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topRow,
          const SizedBox(height: 32),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int qi, bool wide) {
    final q = _questions[qi];
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
              CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFF005B5C),
                child: Text('${qi + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              const Text('Question',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const Spacer(),
              Text('Multiple correct answers',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
              const SizedBox(width: 6),
              Switch.adaptive(
                value: q.isMultiple,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() {
                  q.isMultiple = v;
                  for (final o in q.options) {
                    o.isCorrect = false;
                  }
                }),
              ),
              if (_questions.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                  onPressed: () => _removeQuestion(qi),
                ),
            ],
          ),
          const Divider(color: AppColors.borderLight, height: 24),
          LayoutBuilder(builder: (ctx, constraints) {
            final narrow = constraints.maxWidth < 800;
            final left = _buildLeft(qi, q);
            final right = _buildRight(qi, q);
            if (narrow) {
              return Column(children: [left, const SizedBox(height: 20), right]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: left),
              const SizedBox(width: 24),
              Expanded(child: right),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _buildLeft(int qi, _QuestionDraft q) {
    final hasBytes = q.imagePreviewBytes != null;
    final hasUrl = q.existingImageUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('QUESTION TEXT'),
        const SizedBox(height: 6),
        TextField(
            controller: q.questionController,
            maxLines: 4,
            decoration: _inputDeco('Enter your clinical question here...')),
        const SizedBox(height: 16),
        _label('SUPPORTING IMAGE (OPTIONAL)'),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _pickImage(qi),
          child: (hasBytes || hasUrl)
              ? Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: hasBytes
                          ? Image.memory(q.imagePreviewBytes!, fit: BoxFit.cover)
                          : AppNetworkImage(imageUrl: q.existingImageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _clearImage(qi),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55), shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ])
              : Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.cloud_upload_outlined,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(height: 6),
                    const Text('Click to upload medical diagram',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text('PNG, JPG up to 10 MB',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.7))),
                  ]),
                ),
        ),
      ],
    );
  }

  Widget _buildRight(int qi, _QuestionDraft q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('ANSWER OPTIONS'),
            TextButton.icon(
              onPressed: () => _addOption(qi),
              icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
              label: const Text('Add Option',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...List.generate(
          q.options.length,
          (oi) => Padding(
              padding: const EdgeInsets.only(bottom: 8), child: _buildOptionRow(qi, oi)),
        ),
      ],
    );
  }

  Widget _buildOptionRow(int qi, int oi) {
    final q = _questions[qi];
    final o = q.options[oi];
    final correct = o.isCorrect;

    return Container(
      decoration: BoxDecoration(
        color: correct ? const Color(0xFFE6F2F2) : const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: correct ? AppColors.primary : AppColors.borderLight,
            width: correct ? 1.2 : 1.0),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: o.textController,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: correct ? FontWeight.bold : FontWeight.normal,
                  color: correct ? const Color(0xFF005B5C) : AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Option ${oi + 1}',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _setCorrect(qi, oi, !correct),
              icon: correct
                  ? const Icon(Icons.check_circle, size: 14, color: Colors.white)
                  : const SizedBox.shrink(),
              label: Text(correct ? 'Correct' : 'Set Correct',
                  style: TextStyle(
                      color: correct ? Colors.white : AppColors.textDark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: correct ? const Color(0xFF005B5C) : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                      color: correct ? Colors.transparent : AppColors.borderLight),
                ),
              ),
            ),
            if (q.options.length > 2)
              IconButton(
                onPressed: () => _removeOption(qi, oi),
                icon: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: correct
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.borderLight)),
          ),
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
          child: TextField(
            controller: o.explanationController,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            decoration: const InputDecoration(
              hintText: 'Explanation (optional)',
              hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

Widget _label(String text) => Text(
      text,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          letterSpacing: 0.5),
    );

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

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
          Row(children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
          const Divider(color: AppColors.borderLight, height: 24),
          child,
        ],
      ),
    );
  }
}

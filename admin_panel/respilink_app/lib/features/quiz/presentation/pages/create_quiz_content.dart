import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:shimmer/shimmer.dart';

class CreateQuizContent extends StatefulWidget {
  final VoidCallback onBackToQuizDirectory;

  const CreateQuizContent({
    super.key,
    required this.onBackToQuizDirectory,
  });

  @override
  State<CreateQuizContent> createState() => _CreateQuizContentState();
}

class _CreateQuizContentState extends State<CreateQuizContent> {
  QuizTopicModel? _selectedTopic;
  int _correctOptionIndex = 0; // Tracks which option is set to 'Correct'

  @override
  Widget build(BuildContext context) {
    final bool useVerticalStack = MediaQuery.of(context).size.width < 1100;

    // Shared custom standard input styling decoration configuration
    InputDecoration inputDecoration(String hint) => InputDecoration(
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
        );

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Breadcrumbs Navigation Header & Top Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: widget.onBackToQuizDirectory,
                          child: Text('Quizzes', style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text('/', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ),
                        const Text('Create New Quiz', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create New Quiz',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Design a clinical assessment for healthcare professionals.',
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: widget.onBackToQuizDirectory,
                      child: const Text('Save Draft', style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005B5C),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Publish Quiz', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
        
            // 2. Meta Information Configurations Grid
            Flex(
              direction: useVerticalStack ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // General Information Card (Left/Top)
                Expanded(
                  flex: useVerticalStack ? 0 : 2,
                  child: _ConfigSectionCard(
                    title: 'General Information',
                    icon: Icons.info_outline_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('QUIZ TITLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        TextField(decoration: inputDecoration('e.g., Advanced Respiratory Diagnostics')),
                        const SizedBox(height: 16),
                        const Text('DESCRIPTION (OPTIONAL)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        TextField(
                          maxLines: 3,
                          decoration: inputDecoration('Explain what the clinician will learn...'),
                        ),
                      ],
                    ),
                  ),
                ),
                useVerticalStack ? const SizedBox(height: 16) : const SizedBox(width: 16),
                // Configuration parameters Panel (Right/Bottom)
                Expanded(
                  flex: useVerticalStack ? 0 : 1,
                  child: _ConfigSectionCard(
                    title: 'Configuration',
                    icon: Icons.tune_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOPIC AREA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        BlocBuilder<QuizBloc, QuizState>(
                          builder: (context, state) {
                            if (state.isLoadingTopics) {
                              return Shimmer.fromColors(
                                baseColor: const Color(0xFFE2E8F0),
                                highlightColor: const Color(0xFFF8FAFC),
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            return Container(
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
                                  hint: const Text('Select a topic', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                                  items: state.topics
                                      .map((t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(t.name ?? '', style: const TextStyle(fontSize: 13)),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedTopic = val),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('OPEN PERIOD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: inputDecoration('mm/dd/yyyy').copyWith(
                                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text('to', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: inputDecoration('mm/dd/yyyy').copyWith(
                                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
        
            // 3. Quiz Questions Dynamic Management Sub-Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quiz Questions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005B5C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('1 Question Added', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
        
            // 4. Interactive Core Question Configuration Box Panel
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
                  // Individual Header controls
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: const Color(0xFF005B5C),
                        child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('Multiple Choice Question', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.drag_indicator, size: 18, color: AppColors.textMuted), onPressed: () {}),
                    ],
                  ),
                  const Divider(color: AppColors.borderLight, height: 24),
        
                  // Responsive Horizontal Side-by-Side Splits Configuration
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool insideVerticalStack = constraints.maxWidth < 800;
                      
                      Widget leftColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QUESTION TEXT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.3)),
                          const SizedBox(height: 6),
                          TextField(
                            maxLines: 4,
                            decoration: inputDecoration('Enter your clinical question here...'),
                          ),
                          const SizedBox(height: 16),
                          const Text('SUPPORTING IMAGE (OPTIONAL)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.3)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F8FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image_outlined, size: 24, color: AppColors.textMuted),
                                const SizedBox(height: 6),
                                const Text('Click to upload medical diagram', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                const SizedBox(height: 2),
                                Text('PNG, JPG, up to 10MB', style: TextStyle(fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.7))),
                              ],
                            ),
                          ),
                        ],
                      );
        
                      Widget rightColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ANSWER OPTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.3)),
                              Text('Select one correct answer', style: TextStyle(fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.8))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildOptionRow(0, 'Increased lung compliance'),
                          const SizedBox(height: 8),
                          _buildOptionRow(1, 'Option 2'),
                          const SizedBox(height: 8),
                          _buildOptionRow(2, 'Option 3'),
                          const SizedBox(height: 8),
                          _buildOptionRow(3, 'Option 4'),
                          const SizedBox(height: 16),
                          const Text('EXPLANATION (SHOWN AFTER RESPONSE)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.3)),
                          const SizedBox(height: 6),
                          TextField(
                            maxLines: 2,
                            decoration: inputDecoration('Provide clinical reasoning for the correct answer...'),
                          ),
                        ],
                      );
        
                      if (insideVerticalStack) {
                        return Column(children: [leftColumn, const SizedBox(height: 20), rightColumn]);
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: leftColumn),
                          const SizedBox(width: 24),
                          Expanded(child: rightColumn),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
        
            // 5. Add Another Question Action Button Box Link
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.add, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      const Text('Add Another Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
        
            // 6. Global Bottom Navigation Save Bar Wrapper Area
            const Divider(color: AppColors.borderLight, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.sync, size: 14, color: AppColors.textMuted.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text('Auto-saving as draft...', style: TextStyle(fontSize: 11, color: AppColors.textMuted.withValues(alpha: 0.7))),
                const Spacer(),
                TextButton(
                  onPressed: widget.onBackToQuizDirectory,
                  child: const Text('Discard Changes', style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Text('Next: Review & Settings', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  label: const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Answer Options item block builder widget helper
  Widget _buildOptionRow(int index, String textPlaceholder) {
    final bool isCorrect = _correctOptionIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFE6F2F2) : const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? AppColors.primary : AppColors.borderLight,
          width: isCorrect ? 1.2 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              textPlaceholder,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                color: isCorrect ? const Color(0xFF005B5C) : AppColors.textDark,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => _correctOptionIndex = index),
            icon: isCorrect ? const Icon(Icons.check_circle, size: 14, color: Colors.white) : const SizedBox.shrink(),
            label: Text(
              isCorrect ? 'Correct' : 'Set Correct',
              style: TextStyle(color: isCorrect ? Colors.white : AppColors.textDark, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? const Color(0xFF005B5C) : Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: isCorrect ? Colors.transparent : AppColors.borderLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Layout Helper Widgets
// =========================================================================

class _ConfigSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ConfigSectionCard({required this.title, required this.icon, required this.child});

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
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const Divider(color: AppColors.borderLight, height: 24),
          child,
        ],
      ),
    );
  }
}
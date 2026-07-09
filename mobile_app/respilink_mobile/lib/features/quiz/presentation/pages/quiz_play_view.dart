import 'package:respilink_mobile/features/quiz/domain/models/quiz_question_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_answer_option.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_progress_header.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_question_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_question_image.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_submit_button.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the quiz-taking API is wired up.
const _question = QuizQuestionModel(
  questionNumber: 3,
  totalQuestions: 10,
  image: 'take_quiz.png',
  questionText:
      'Based on the CXR findings, which clinical intervention is prioritized for this pulmonary edema presentation?',
  caseContext:
      'A 64-year-old male presents with acute onset dyspnea and bilateral crackles. Heart rate is 105 bpm.',
  options: [
    QuizAnswerOption(label: 'A', text: 'Administer loop diuretics intravenously'),
    QuizAnswerOption(label: 'B', text: 'Initiate non-invasive positive pressure ventilation'),
    QuizAnswerOption(label: 'C', text: 'Perform immediate needle thoracostomy'),
    QuizAnswerOption(label: 'D', text: 'Administer broad-spectrum antibiotics'),
  ],
  timeLimitSeconds: 15,
);

class QuizPlayView extends StatefulWidget {
  const QuizPlayView({super.key});

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  int? _selectedIndex = 1;

  void _submit() {
    if (_selectedIndex == null) return;
    // TODO: submit the answer to the quiz API and advance to the next question.
    locator<NavigationService>().navigate(RouterStrings.quizResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: QuizAppBar(
        timeLimitSeconds: _question.timeLimitSeconds,
        onTimeExpired: _submit,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuizProgressHeader(
                questionNumber: _question.questionNumber,
                totalQuestions: _question.totalQuestions,
                progress: _question.progress,
              ),

              SizedBox(height: 20.h),

              QuizQuestionImage(image: _question.image),

              SizedBox(height: 18.h),

              QuizQuestionCard(
                questionText: _question.questionText,
                caseContext: _question.caseContext,
              ),

              SizedBox(height: 18.h),

              for (int i = 0; i < _question.options.length; i++) ...[
                QuizAnswerOptionTile(
                  option: _question.options[i],
                  isSelected: _selectedIndex == i,
                  onTap: () => setState(() => _selectedIndex = i),
                ),
                SizedBox(height: 12.h),
              ],

              SizedBox(height: 8.h),

              QuizSubmitButton(
                onTap: _selectedIndex != null ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_state.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_answer_option.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_progress_header.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_question_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_question_image.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_submit_button.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class QuizPlayView extends StatefulWidget {
  final int quizId;

  const QuizPlayView({super.key, required this.quizId});

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  @override
  void initState() {
    super.initState();
    context.read<QuizPlayBloc>().add(
      QuizQuestionsRequested(quizId: widget.quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizPlayBloc, QuizPlayState>(
      listener: (context, state) {
        if (state is QuizPlayFailed) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
        } else if (state is QuizPlayLoaded && state.submitError != null) {
          SnackbarUtil.showSnackbar(
            message: state.submitError!,
            isError: true,
          );
        } else if (state is QuizPlayCompleted) {
          SnackbarUtil.showSnackbar(message: "Quiz submitted successfully.");
          locator<NavigationService>().navigate(
            RouterStrings.quizReview,
            arguments: widget.quizId,
          );
        } else if (state is QuizPlayTimeExpired) {
          SnackbarUtil.showSnackbar(message: "Time's up! Your answers have been submitted.");
          locator<NavigationService>().navigateAndRemove(RouterStrings.dashboard);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: QuizAppBar(
            timeLimitSeconds: state is QuizPlayLoaded
                ? state.quiz.timeLimit
                : null,
            onTimeExpired: () =>
                context.read<QuizPlayBloc>().add(QuizTimeExpired()),
          ),
          body: SafeArea(top: false, child: _buildBody(context, state)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, QuizPlayState state) {
    if (state is QuizPlayFailed) {
      return RequestFailed(message: state.message);
    }

    if (state is! QuizPlayLoaded) {
      return AppSkeleton.cardList();
    }

    final question = state.currentQuestion;
    final isMultiSelect = question.isMultiple ?? false;
    final hasImage = question.image != null && question.image!.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuizProgressHeader(
            questionNumber: state.currentIndex + 1,
            totalQuestions: state.questions.length,
            progress: (state.currentIndex + 1) / state.questions.length,
          ),

          SizedBox(height: 20.h),

          if (hasImage) ...[
            QuizQuestionImage(image: question.image!),
            SizedBox(height: 18.h),
          ],

          QuizQuestionCard(questionText: question.questionText ?? ''),

          SizedBox(height: 18.h),

          for (final option in question.options ?? const [])
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: QuizAnswerOptionTile(
                option: option,
                isMultiSelect: isMultiSelect,
                isSelected: state.selectedOptionIds.contains(option.id),
                onTap: () => context.read<QuizPlayBloc>().add(
                  QuizOptionToggled(optionId: option.id ?? 0),
                ),
              ),
            ),

          SizedBox(height: 8.h),

          QuizSubmitButton(
            isLoading: state.isSubmitting,
            isLastQuestion: state.isLastQuestion,
            onTap: state.selectedOptionIds.isNotEmpty
                ? () => context.read<QuizPlayBloc>().add(QuizAnswerSubmitted())
                : null,
          ),
        ],
      ),
    );
  }
}

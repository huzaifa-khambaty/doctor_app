import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_state.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_review_question_card.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class QuizReviewView extends StatefulWidget {
  final int quizId;

  const QuizReviewView({super.key, required this.quizId});

  @override
  State<QuizReviewView> createState() => _QuizReviewViewState();
}

class _QuizReviewViewState extends State<QuizReviewView> {
  @override
  void initState() {
    super.initState();
    context.read<QuizReviewBloc>().add(
      QuizReviewRequested(quizId: widget.quizId),
    );
  }

  void _exitToDashboard() {
    locator<NavigationService>().navigateAndRemove(RouterStrings.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _exitToDashboard();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
              color: AppColors.black,
            ),
            onPressed: _exitToDashboard,
          ),
          title: AppText.medium(
            label: 'Quiz Review',
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        body: SafeArea(top: false, child: _buildBody()),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => locator<NavigationService>().navigate(
                  RouterStrings.quizResults,
                  arguments: widget.quizId,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: AppText.medium(
                  label: 'Get Quiz Results',
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<QuizReviewBloc, QuizReviewState>(
      listener: (context, state) {
        if (state is QuizReviewFailed) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        if (state is QuizReviewFailed) {
          return RequestFailed(message: state.message);
        }

        if (state is! QuizReviewLoaded) {
          return AppSkeleton.cardList();
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          itemCount: state.questions.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) => QuizReviewQuestionCard(
            questionNumber: index + 1,
            question: state.questions[index],
          ),
        );
      },
    );
  }
}

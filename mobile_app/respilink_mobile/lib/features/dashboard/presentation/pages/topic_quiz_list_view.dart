import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_state.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/quiz_summary_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_state.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class TopicQuizListView extends StatefulWidget {
  final SpecializedTopicModel topic;

  const TopicQuizListView({super.key, required this.topic});

  @override
  State<TopicQuizListView> createState() => _TopicQuizListViewState();
}

class _TopicQuizListViewState extends State<TopicQuizListView> {
  int? _startingQuizId;

  @override
  void initState() {
    super.initState();
    context.read<QuizListBloc>().add(
      QuizListRequested(topicId: widget.topic.id),
    );
  }

  void _startQuiz(QuizSummary quiz) {
    final quizId = quiz.id;
    if (quizId == null || _startingQuizId != null) return;

    setState(() => _startingQuizId = quizId);
    context.read<QuizAttemptBloc>().add(
      QuizAttemptStartRequested(quizId: quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizAttemptBloc, QuizAttemptState>(
      listener: (context, attemptState) {
        if (attemptState is QuizAttemptStarted) {
          setState(() => _startingQuizId = null);
          locator<NavigationService>().navigate(
            RouterStrings.quizPlay,
            arguments: attemptState.quizId,
          );
        } else if (attemptState is QuizAttemptFailed) {
          setState(() => _startingQuizId = null);
          SnackbarUtil.showSnackbar(
            message: attemptState.message,
            isError: true,
          );
        }
      },
      child: BlocConsumer<QuizListBloc, QuizListState>(
        listener: (context, state) {
          if (state is QuizListFailed) {
            SnackbarUtil.showSnackbar(message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          final title =
              (state is QuizListLoaded ? state.topic?.name : null) ??
              widget.topic.title;

          return Scaffold(
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
                onPressed: () => locator<NavigationService>().pop(),
              ),
              title: AppText.medium(
                label: title,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            body: SafeArea(top: false, child: _buildBody(state)),
          );
        },
      ),
    );
  }

  Widget _buildBody(QuizListState state) {
    if (state is QuizListFailed) {
      return RequestFailed(message: state.message);
    }

    if (state is! QuizListLoaded) {
      return AppSkeleton.cardList();
    }

    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<QuizListBloc>().add(
          QuizListRequested(topicId: widget.topic.id),
        );
      },
      isEmpty: state.quizzes.isEmpty,
      emptyWidget: const RequestFailed(message: 'No quizzes found for this topic.'),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.quizzes.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final quiz = state.quizzes[index];
          return QuizSummaryCard(
            quiz: quiz,
            isLoading: _startingQuizId != null && _startingQuizId == quiz.id,
            onTap: () => _startQuiz(quiz),
          );
        },
      ),
    );
  }
}

abstract class QuizPlayEvent {}

class QuizQuestionsRequested extends QuizPlayEvent {
  final int quizId;

  QuizQuestionsRequested({required this.quizId});
}

class QuizOptionToggled extends QuizPlayEvent {
  final int optionId;

  QuizOptionToggled({required this.optionId});
}

class QuizAnswerSubmitted extends QuizPlayEvent {
  QuizAnswerSubmitted();
}

class QuizTimeExpired extends QuizPlayEvent {
  QuizTimeExpired();
}

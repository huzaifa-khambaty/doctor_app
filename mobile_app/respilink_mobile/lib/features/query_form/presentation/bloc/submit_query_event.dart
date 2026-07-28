abstract class SubmitQueryEvent {}

class SubmitQueryRequested extends SubmitQueryEvent {
  final int categoryId;
  final String subject;
  final String message;

  SubmitQueryRequested({
    required this.categoryId,
    required this.subject,
    required this.message,
  });
}

abstract class SubmitQueryState {}

class SubmitQueryInitial extends SubmitQueryState {}

class SubmitQueryLoading extends SubmitQueryState {}

class SubmitQuerySuccess extends SubmitQueryState {
  final String message;

  SubmitQuerySuccess({required this.message});
}

class SubmitQueryFailed extends SubmitQueryState {
  final String message;

  SubmitQueryFailed({required this.message});
}

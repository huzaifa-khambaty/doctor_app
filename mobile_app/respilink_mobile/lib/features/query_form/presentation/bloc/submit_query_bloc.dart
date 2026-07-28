import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/query_form/data/model/requests/submit_query_request.dart';
import 'package:respilink_mobile/features/query_form/domain/repositories/query_form_repository.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/submit_query_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/submit_query_state.dart';

class SubmitQueryBloc extends Bloc<SubmitQueryEvent, SubmitQueryState> {
  final QueryFormRepository _repository;

  SubmitQueryBloc(this._repository) : super(SubmitQueryInitial()) {
    on<SubmitQueryRequested>(_submitQuery);
  }

  Future<void> _submitQuery(
    SubmitQueryRequested event,
    Emitter<SubmitQueryState> emit,
  ) async {
    emit(SubmitQueryLoading());

    final res = await _repository.submitQuery(
      SubmitQueryRequest(
        categoryId: event.categoryId,
        subject: event.subject,
        message: event.message,
      ),
    );

    if (res.success) {
      final message = res.message;
      emit(
        SubmitQuerySuccess(
          message: (message != null && message.isNotEmpty)
              ? message
              : 'Query submitted successfully.',
        ),
      );
    } else {
      emit(SubmitQueryFailed(message: res.fullErrorMessage));
    }
  }
}

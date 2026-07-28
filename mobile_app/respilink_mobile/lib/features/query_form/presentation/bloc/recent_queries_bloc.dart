import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/query_form/domain/repositories/query_form_repository.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/recent_queries_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/recent_queries_state.dart';

class RecentQueriesBloc extends Bloc<RecentQueriesEvent, RecentQueriesState> {
  final QueryFormRepository _repository;

  RecentQueriesBloc(this._repository) : super(RecentQueriesLoading()) {
    on<RecentQueriesRequested>(_fetchQueries);
  }

  Future<void> _fetchQueries(
    RecentQueriesRequested event,
    Emitter<RecentQueriesState> emit,
  ) async {
    emit(RecentQueriesLoading());

    final res = await _repository.getQueries();

    if (res.success && res.data != null) {
      emit(RecentQueriesLoaded(queries: res.data!.data ?? const []));
    } else {
      emit(RecentQueriesFailed(message: res.fullErrorMessage));
    }
  }
}

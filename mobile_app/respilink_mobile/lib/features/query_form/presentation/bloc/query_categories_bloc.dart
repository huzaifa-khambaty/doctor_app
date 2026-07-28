import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/query_form/domain/repositories/query_form_repository.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/query_categories_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/query_categories_state.dart';

class QueryCategoriesBloc
    extends Bloc<QueryCategoriesEvent, QueryCategoriesState> {
  final QueryFormRepository _repository;

  QueryCategoriesBloc(this._repository) : super(QueryCategoriesLoading()) {
    on<QueryCategoriesRequested>(_fetchCategories);
  }

  Future<void> _fetchCategories(
    QueryCategoriesRequested event,
    Emitter<QueryCategoriesState> emit,
  ) async {
    emit(QueryCategoriesLoading());

    final res = await _repository.getQueryCategories();

    if (res.success && res.data != null) {
      emit(QueryCategoriesLoaded(categories: res.data!));
    } else {
      emit(QueryCategoriesFailed(message: res.fullErrorMessage));
    }
  }
}

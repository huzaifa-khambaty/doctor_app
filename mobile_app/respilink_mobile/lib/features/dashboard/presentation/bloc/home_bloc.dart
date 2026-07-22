import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/home_repository.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/home_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeLoading()) {
    on<HomeRequested>(_fetchHome);
  }

  Future<void> _fetchHome(HomeRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final res = await _repository.getHome();

    if (res.success && res.data != null) {
      emit(HomeLoaded(model: res.data!));
    } else {
      emit(HomeFailed(message: res.fullErrorMessage));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/connectivity_service.dart';

class ConnectivityCubit extends Cubit<bool> {
  final ConnectivityService _service;
  late StreamSubscription _subscription;

  ConnectivityCubit(this._service) : super(true) {
    _init();
  }

  void _init() {
    _subscription = _service.isOnline.listen((isOnline) {
      emit(isOnline);
    });
  }

  Future<bool> checkNow() => _service.currentlyOnline;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
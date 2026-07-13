import 'package:respilink_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<UserAuthenticationRequested>(_isUserLoggedIn);
    on<LoginRequested>(_login);

    on<LogoutRequested>(_logout);

    on<UpdateProfileEvent>(_updateProfile);

    on<ForgetPasswordRequested>(_forgetPassword);
    on<ResetPasswordRequested>(_resetPassword);
  }

  void _isUserLoggedIn(
    UserAuthenticationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.isUserLoggedIn();

    if (res.data == true) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void _login(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.login(event.request);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _repository.logout();
    emit(AuthLogoutSuccess());
  }

  void _updateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.updateProfile(event.request);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _forgetPassword(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.forgetPassword(event.request);

    if (res.success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _resetPassword(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.resetPassword(event.request);

    if (res.success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }
}

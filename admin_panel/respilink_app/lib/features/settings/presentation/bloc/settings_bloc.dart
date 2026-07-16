import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/settings/data/model/requests/assign_permissions_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_admin_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_update_role_request.dart';
import 'package:respilink_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(const SettingsState()) {
    on<FetchRolesRequested>(_fetchRoles);
    on<FetchPermissionsRequested>(_fetchPermissions);
    on<AssignPermissionsRequested>(_assignPermissions);
    on<CreateRoleRequested>(_createRole);
    on<UpdateRoleRequested>(_updateRole);
    on<DeleteRoleRequested>(_deleteRole);
    on<FetchAdminsRequested>(_fetchAdmins);
    on<CreateAdminRequested>(_createAdmin);
    on<UpdateAdminRequested>(_updateAdmin);
    on<DeleteAdminRequested>(_deleteAdmin);
  }

  Future<void> _fetchRoles(
    FetchRolesRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoadingRoles: true));
    final res = await _repository.getRoles();
    if (res.success && res.data != null) {
      emit(state.copyWith(roles: res.data!, isLoadingRoles: false));
    } else {
      emit(state.copyWith(isLoadingRoles: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchPermissions(
    FetchPermissionsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoadingPermissions: true));
    final res = await _repository.getPermissions();
    if (res.success && res.data != null) {
      emit(state.copyWith(permissions: res.data!, isLoadingPermissions: false));
    } else {
      emit(
        state.copyWith(
          isLoadingPermissions: false,
          error: res.fullErrorMessage,
        ),
      );
    }
  }

  Future<void> _assignPermissions(
    AssignPermissionsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));
    final res = await _repository.assignPermissions(
      roleId: event.roleId,
      request: AssignPermissionsRequest(event.permissionIds),
    );
    if (res.success) {
      emit(state.copyWith(isSaving: false, saveSuccess: true));
      add(FetchRolesRequested());
    } else {
      emit(state.copyWith(isSaving: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _createRole(
    CreateRoleRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isCreatingRole: true));
    final res = await _repository.createRole(CreateUpdateRoleRequest(event.name));
    if (res.success) {
      emit(state.copyWith(isCreatingRole: false, createRoleSuccess: true));
      add(FetchRolesRequested());
    } else {
      emit(
        state.copyWith(isCreatingRole: false, error: res.fullErrorMessage),
      );
    }
  }

  Future<void> _updateRole(
    UpdateRoleRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isUpdatingRole: true));
    final res = await _repository.updateRole(
      event.roleId,
      CreateUpdateRoleRequest(event.name),
    );
    if (res.success) {
      emit(state.copyWith(isUpdatingRole: false, updateRoleSuccess: true));
      add(FetchRolesRequested());
    } else {
      emit(
        state.copyWith(isUpdatingRole: false, error: res.fullErrorMessage),
      );
    }
  }

  Future<void> _deleteRole(
    DeleteRoleRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isDeletingRole: true));
    final res = await _repository.deleteRole(event.roleId);
    if (res.success) {
      emit(state.copyWith(isDeletingRole: false, deleteRoleSuccess: true));
      add(FetchRolesRequested());
    } else {
      emit(
        state.copyWith(isDeletingRole: false, error: res.fullErrorMessage),
      );
    }
  }

  Future<void> _fetchAdmins(
    FetchAdminsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoadingAdmins: true));
    final res = await _repository.getAdmins();
    if (res.success && res.data != null) {
      emit(state.copyWith(admins: res.data!, isLoadingAdmins: false));
    } else {
      emit(state.copyWith(isLoadingAdmins: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _createAdmin(
    CreateAdminRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isCreatingAdmin: true));
    final res = await _repository.createAdmin(
      CreateAdminRequest(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        roles: event.roles,
      ),
    );
    if (res.success) {
      emit(state.copyWith(isCreatingAdmin: false, createAdminSuccess: true));
      add(FetchAdminsRequested());
    } else {
      emit(state.copyWith(isCreatingAdmin: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _updateAdmin(
    UpdateAdminRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isUpdatingAdmin: true));
    final res = await _repository.updateAdmin(
      event.adminId,
      UpdateAdminRequest(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        roles: event.roles,
      ),
    );
    if (res.success) {
      emit(state.copyWith(isUpdatingAdmin: false, updateAdminSuccess: true));
      add(FetchAdminsRequested());
    } else {
      emit(state.copyWith(isUpdatingAdmin: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _deleteAdmin(
    DeleteAdminRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isDeletingAdmin: true));
    final res = await _repository.deleteAdmin(event.adminId);
    if (res.success) {
      emit(state.copyWith(isDeletingAdmin: false, deleteAdminSuccess: true));
      add(FetchAdminsRequested());
    } else {
      emit(state.copyWith(isDeletingAdmin: false, error: res.fullErrorMessage));
    }
  }
}

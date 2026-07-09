import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';

import '../../exports.dart';
import '../../services/pusher_service.dart';

class Handlers {
  Handlers._();

  static void onLogin(Doctor? model) async {
    GlobalNotifiers.userNotifier.value = model;
    await locator<PusherService>().initPusher();
    locator<NavigationService>().navigateAndRemove(RouterStrings.dashboard);
  }

  static void onRegister(Doctor? model) {
    GlobalNotifiers.userNotifier.value = model;
    locator<NavigationService>().navigateAndRemove(
      RouterStrings.otpVerificationView,
      arguments: {"email": model?.email, "purpose": "register"},
    );
  }

  static void onForgetPassword(String email) {
    locator<NavigationService>().navigateAndRemove(
      RouterStrings.otpVerificationView,
      arguments: {"email": email, "purpose": "reset"},
    );
  }

  static void onOtpVerified(Doctor? model) async {
    GlobalNotifiers.userNotifier.value = model;
    await locator<PusherService>().initPusher();
    locator<NavigationService>().navigateAndRemove(RouterStrings.dashboard);
  }

  static void onOtpVerifiedReset(String email, String code) async {
    locator<NavigationService>().navigateAndRemove(
      RouterStrings.resetPassword,
      arguments: {"email": email, "code": code},
    );
  }

  static void onProfileUpdated(Doctor? model) {
    SnackbarUtil.showSnackbar(message: "Profile updated.");
    GlobalNotifiers.userNotifier.value = model;
    locator<NavigationService>().pop();
  }

  static void onPasswordChanged() {
    SnackbarUtil.showSnackbar(message: "Password changed successfully");
    locator<NavigationService>().navigateAndRemove(RouterStrings.login);
  }

    static void onPasswordReset() {
    SnackbarUtil.showSnackbar(message: "Password reset successfully");
    locator<NavigationService>().navigateAndRemove(RouterStrings.login);
  }

  static void onLogout(BuildContext context) async {
    await locator<PusherService>().disconnect();
    BlocProvider.of<DashboardBloc>(context).add(ChangeTabRequested(0));
    locator<NavigationService>().navigateAndRemove(RouterStrings.login);
  }
}

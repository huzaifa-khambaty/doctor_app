import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/auth/auth_injections.dart';
import 'package:respilink_mobile/features/dashboard/dashboard_injections.dart';
import 'package:respilink_mobile/features/events/events_injections.dart';
import 'package:respilink_mobile/features/onboarding/data/onboarding_local_manager.dart';
import 'package:respilink_mobile/services/biometric_auth_service.dart';
import 'package:respilink_mobile/services/pusher_service.dart';
import 'exports.dart';

final locator = GetIt.instance;

void initDependencies() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  locator.registerLazySingleton<BiometricAuthService>(() => BiometricAuthService());
  locator.registerLazySingleton<PusherService>(() => PusherService());

  /// Secure storage — singleton so every consumer shares one instance.
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  AuthInjections.setupAuthInjections();
  DashboardInjections.setupDashboardInjections();
  EventsInjections.setupEventsInjections();

  locator.registerLazySingleton<OnboardingLocalManager>(
    () => OnboardingLocalManagerImpl(locator()),
  );

  /// Services
  locator.registerFactory<Dio>(() => Dio());
  DioClient.init();
}
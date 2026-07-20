import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/features/auth/auth_injections.dart';
import 'package:respilink_app/features/content/content_injections.dart';
import 'package:respilink_app/features/events/events_injections.dart';
import 'package:respilink_app/features/practioner/practioner_injections.dart';
import 'package:respilink_app/features/quiz/quiz_injections.dart';
import 'package:respilink_app/features/settings/settings_injections.dart';
import 'package:respilink_app/service/pusher_service.dart';

final locator = GetIt.instance;

void initDependencies() {
  locator.registerLazySingleton<PusherService>(() => PusherService());

  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  AuthInjections.setupAuthInjections();
  PractionerInjections.setupPractionerInjections();
  EventsInjections.setupEventsInjections();
  SettingsInjections.setupSettingsInjections();
  QuizInjections.setupQuizInjections();
  ContentInjections.setupContentInjections();

  locator.registerFactory<Dio>(() => Dio());
  DioClient.init();
}

import 'package:respilink_app/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:respilink_app/features/quiz/data/sources/quiz_remote_data_source.dart';
import 'package:respilink_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:respilink_app/injections.dart';

class QuizInjections {
  QuizInjections._();

  static void setupQuizInjections() {
    locator.registerLazySingleton<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(locator()),
    );
    locator.registerFactory<QuizBloc>(() => QuizBloc(locator()));
  }
}

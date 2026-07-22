import 'package:respilink_mobile/features/dashboard/data/model/home_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeModel model;

  HomeLoaded({required this.model});
}

class HomeFailed extends HomeState {
  final String message;

  HomeFailed({required this.message});
}

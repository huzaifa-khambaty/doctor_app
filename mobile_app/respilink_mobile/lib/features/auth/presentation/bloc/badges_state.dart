import 'package:respilink_mobile/features/dashboard/data/model/badge_model.dart';

abstract class BadgesState {}

class BadgesLoading extends BadgesState {}

class BadgesLoaded extends BadgesState {
  final BadgeModel badges;

  BadgesLoaded({required this.badges});
}

class BadgesFailed extends BadgesState {
  final String message;

  BadgesFailed({required this.message});
}

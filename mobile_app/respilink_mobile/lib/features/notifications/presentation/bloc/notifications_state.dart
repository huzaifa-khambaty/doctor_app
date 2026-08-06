import 'package:respilink_mobile/features/notifications/data/models/notification_model.dart';

abstract class NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded({required this.notifications});
}

class NotificationsFailed extends NotificationsState {
  final String message;

  NotificationsFailed({required this.message});
}

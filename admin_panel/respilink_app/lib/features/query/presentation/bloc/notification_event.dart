import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationEvent {}

class FetchNotificationsRequested extends NotificationEvent {
  final int page;
  FetchNotificationsRequested({this.page = 1});
}

class FetchVerifiedDoctorsCountRequested extends NotificationEvent {}

class CreateNotificationRequested extends NotificationEvent {
  final CreateNotificationRequest request;
  CreateNotificationRequested(this.request);
}

class UpdateNotificationRequested extends NotificationEvent {
  final int id;
  final CreateNotificationRequest request;
  UpdateNotificationRequested({required this.id, required this.request});
}

class CancelNotificationRequested extends NotificationEvent {
  final int id;
  CancelNotificationRequested({required this.id});
}

class DeleteNotificationRequested extends NotificationEvent {
  final int id;
  DeleteNotificationRequested({required this.id});
}

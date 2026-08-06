import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationEvent {}

class FetchVerifiedDoctorsCountRequested extends NotificationEvent {}

class CreateNotificationRequested extends NotificationEvent {
  final CreateNotificationRequest request;
  CreateNotificationRequested(this.request);
}

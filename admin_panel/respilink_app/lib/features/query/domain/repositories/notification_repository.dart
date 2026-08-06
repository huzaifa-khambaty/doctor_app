import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/query/data/model/all_notifications_model.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationRepository {
  Future<ApiResponse<Notifications>> getNotifications({int page = 1});
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request);
  Future<ApiResponse<dynamic>> updateNotification(int id, CreateNotificationRequest request);
  Future<ApiResponse<dynamic>> cancelNotification(int id);
  Future<ApiResponse<dynamic>> deleteNotification(int id);
}

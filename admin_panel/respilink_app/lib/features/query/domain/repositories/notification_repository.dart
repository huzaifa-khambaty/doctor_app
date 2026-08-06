import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationRepository {
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request);
}

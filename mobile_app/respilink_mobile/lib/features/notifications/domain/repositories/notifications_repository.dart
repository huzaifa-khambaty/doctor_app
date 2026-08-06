import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<ApiResponse<List<NotificationModel>>> getNotifications();
}

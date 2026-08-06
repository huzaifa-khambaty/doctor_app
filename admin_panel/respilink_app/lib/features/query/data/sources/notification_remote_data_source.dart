import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/query/data/model/all_notifications_model.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationRemoteDataSource {
  Future<ApiResponse<Notifications>> getNotifications({int page = 1});
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request);
  Future<ApiResponse<dynamic>> updateNotification(int id, CreateNotificationRequest request);
  Future<ApiResponse<dynamic>> cancelNotification(int id);
  Future<ApiResponse<dynamic>> deleteNotification(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<Notifications>> getNotifications({int page = 1}) {
    return _client.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page},
      fromJson: (json) => Notifications.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request) {
    return _client.post(
      ApiEndpoints.notifications,
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> updateNotification(int id, CreateNotificationRequest request) {
    return _client.put(
      '${ApiEndpoints.notifications}/$id',
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> cancelNotification(int id) {
    return _client.post('${ApiEndpoints.notifications}/$id/cancel');
  }

  @override
  Future<ApiResponse<dynamic>> deleteNotification(int id) {
    return _client.delete('${ApiEndpoints.notifications}/$id');
  }
}

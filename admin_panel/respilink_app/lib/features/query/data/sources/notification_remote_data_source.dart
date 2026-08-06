import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';

abstract class NotificationRemoteDataSource {
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request) {
    return _client.post(
      ApiEndpoints.notifications,
      data: request.toJson(),
    );
  }
}

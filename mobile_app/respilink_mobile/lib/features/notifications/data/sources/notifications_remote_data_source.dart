import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/notifications/data/models/notification_model.dart';

import '../../../../core/network/models/api_response.dart';

abstract class NotificationsRemoteDataSource {
  Future<ApiResponse<List<NotificationModel>>> getNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    return _client.get(
      ApiEndpoints.notifications,
      fromJson: (json) {
        // Laravel resource collections wrap arrays as {"data": [...]},
        // but some endpoints in this API return a bare array — handle both.
        final list = json is List
            ? json
            : (json as Map<String, dynamic>)['data'] as List;
        return list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}

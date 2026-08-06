import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/query/data/model/requests/create_notification_request.dart';
import 'package:respilink_app/features/query/data/sources/notification_remote_data_source.dart';
import 'package:respilink_app/features/query/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<dynamic>> createNotification(CreateNotificationRequest request) {
    return _remoteDataSource.createNotification(request);
  }
}

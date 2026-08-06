import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/notifications/data/models/notification_model.dart';
import 'package:respilink_mobile/features/notifications/data/sources/notifications_remote_data_source.dart';
import 'package:respilink_mobile/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications() {
    return _remoteDataSource.getNotifications();
  }
}

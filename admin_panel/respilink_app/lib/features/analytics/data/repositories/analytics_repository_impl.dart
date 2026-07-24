import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/analytics/data/model/analytics_model.dart';
import 'package:respilink_app/features/analytics/data/sources/analytics_remote_data_source.dart';
import 'package:respilink_app/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource _remoteDataSource;

  AnalyticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<AnalyticsModel>> getAnalytics({String period = 'weekly'}) =>
      _remoteDataSource.getAnalytics(period: period);
}

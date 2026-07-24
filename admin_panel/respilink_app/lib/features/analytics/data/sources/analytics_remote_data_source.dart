import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/analytics/data/model/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<ApiResponse<AnalyticsModel>> getAnalytics({String period = 'weekly'});
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<AnalyticsModel>> getAnalytics({String period = 'weekly'}) async {
    return _client.get(
      "${ApiEndpoints.analytics}/engagement?period=$period",
      fromJson: (json) => AnalyticsModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

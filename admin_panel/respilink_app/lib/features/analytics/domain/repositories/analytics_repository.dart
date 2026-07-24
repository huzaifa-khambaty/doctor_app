import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/analytics/data/model/analytics_model.dart';

abstract class AnalyticsRepository {
  Future<ApiResponse<AnalyticsModel>> getAnalytics({String period = 'weekly'});
}

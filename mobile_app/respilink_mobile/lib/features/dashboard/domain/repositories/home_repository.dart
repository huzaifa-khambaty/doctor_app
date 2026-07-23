import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/dashboard/data/model/home_model.dart';

abstract class HomeRepository {
  Future<ApiResponse<HomeModel>> getHome();
}

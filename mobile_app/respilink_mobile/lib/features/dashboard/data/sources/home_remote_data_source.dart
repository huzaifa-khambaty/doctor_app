import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/dashboard/data/model/home_model.dart';

import '../../../../core/network/models/api_response.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<HomeModel>> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<HomeModel>> getHome() async {
    return _client.get(
      ApiEndpoints.home,
      fromJson: (json) => HomeModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

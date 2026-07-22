import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/dashboard/data/model/home_model.dart';
import 'package:respilink_mobile/features/dashboard/data/sources/home_remote_data_source.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<HomeModel>> getHome() {
    return _remoteDataSource.getHome();
  }
}

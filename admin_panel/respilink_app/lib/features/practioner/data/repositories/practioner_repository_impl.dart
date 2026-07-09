import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';
import 'package:respilink_app/features/practioner/data/model/specialities_model.dart';
import 'package:respilink_app/features/practioner/data/sources/practioner_remote_data_source.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';

class PractionerRepositoryImpl implements PractionerRepository {
  final PractionerRemoteDataSource _remoteDataSource;

  PractionerRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<SpecialitiesModel>>> getSpecialties() =>
      _remoteDataSource.getSpecialties();

  @override
  Future<ApiResponse<PractionersModel>> getPractioners({
    int page = 1,
    String? status,
    int? specialtyId,
  }) =>
      _remoteDataSource.getPractioners(
        page: page,
        status: status,
        specialtyId: specialtyId,
      );

  @override
  Future<ApiResponse<dynamic>> verifyPractioner({required int userId}) =>
      _remoteDataSource.verifyPractioner(userId: userId);

  @override
  Future<ApiResponse<dynamic>> rejectPractioner({required int userId}) =>
      _remoteDataSource.rejectPractioner(userId: userId);

  @override
  Future<ApiResponse<dynamic>> suspendPractioner({
    required int userId,
    required SuspendUserRequest request,
  }) =>
      _remoteDataSource.suspendPractioner(userId: userId, request: request);

  @override
  Future<ApiResponse<dynamic>> reinstatePractioner({required int userId}) =>
      _remoteDataSource.reinstatePractioner(userId: userId);
}

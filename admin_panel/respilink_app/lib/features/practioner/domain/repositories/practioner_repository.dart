import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/data/model/requests/create_practioner_request.dart';
import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';
import 'package:respilink_app/features/practioner/data/model/specialities_model.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class PractionerRepository {
  Future<ApiResponse<List<SpecialitiesModel>>> getSpecialties();
  Future<ApiResponse<PractionersModel>> getPractioners({
    int page = 1,
    String? status,
    int? specialtyId,
  });
  Future<ApiResponse<dynamic>> createPractioner(CreatePractionerRequest request, {PickedImage? photo});
  Future<ApiResponse<dynamic>> verifyPractioner({required int userId});
  Future<ApiResponse<dynamic>> rejectPractioner({required int userId});
  Future<ApiResponse<dynamic>> suspendPractioner({required int userId, required SuspendUserRequest request});
  Future<ApiResponse<dynamic>> reinstatePractioner({required int userId});
}

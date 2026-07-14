import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/data/model/requests/create_practioner_request.dart';
import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';
import 'package:respilink_app/features/practioner/data/model/specialities_model.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class PractionerRemoteDataSource {
  Future<ApiResponse<List<SpecialitiesModel>>> getSpecialties();
  Future<ApiResponse<PractionersModel>> getPractioners({
    int page = 1,
    String? status,
    int? specialtyId,
  });
  Future<ApiResponse<dynamic>> createPractioner(CreatePractionerRequest request, {PickedImage? photo});
  Future<ApiResponse<dynamic>> verifyPractioner({required int userId});
  Future<ApiResponse<dynamic>> rejectPractioner({required int userId, String? reason});
  Future<ApiResponse<dynamic>> suspendPractioner({required int userId, required SuspendUserRequest request});
  Future<ApiResponse<dynamic>> reinstatePractioner({required int userId});
}

class PractionerRemoteDataSourceImpl implements PractionerRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<SpecialitiesModel>>> getSpecialties() async {
    return _client.get(
      ApiEndpoints.specialties,
      fromJson: (json) =>
          (json as List).map((e) => SpecialitiesModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<PractionersModel>> getPractioners({
    int page = 1,
    String? status,
    int? specialtyId,
  }) async {
    return _client.get(
      ApiEndpoints.practioners,
      queryParameters: {
        'page': page,
        'status': ?status,
        'specialty_id': ?specialtyId,
      },
      fromJson: (json) =>
          PractionersModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<dynamic>> createPractioner(CreatePractionerRequest request, {PickedImage? photo}) {
    final formData = FormData();
    formData.fields
      ..add(MapEntry('full_name', request.name))
      ..add(MapEntry('email', request.email))
      ..add(MapEntry('phone', request.phone))
      ..add(MapEntry('password', request.password))
      ..add(MapEntry('license_number', request.licenseNumber))
      ..add(MapEntry('hospital_affiliation', request.hospitalAffiliation))
      ..add(MapEntry('year_of_registration', request.yearOfRegistration));
    for (final id in request.specialtyIds) {
      formData.fields.add(MapEntry('specialties[]', id.toString()));
    }
    if (photo != null) {
      formData.files.add(MapEntry(
        'photo',
        MultipartFile.fromBytes(
          photo.bytes,
          filename: photo.name,
          contentType: MediaType.parse(photo.mimeType),
        ),
      ));
    }
    return _client.upload(ApiEndpoints.practioners, formData: formData);
  }

  @override
  Future<ApiResponse<dynamic>> verifyPractioner({required int userId}) async {
    return _client.post('${ApiEndpoints.practioners}/$userId/verify');
  }

  @override
  Future<ApiResponse<dynamic>> rejectPractioner({required int userId, String? reason}) async {
    return _client.post(
      '${ApiEndpoints.practioners}/$userId/reject',
      data: reason != null && reason.isNotEmpty ? {'reason': reason} : {},
    );
  }

  @override
  Future<ApiResponse<dynamic>> suspendPractioner({
    required int userId,
    required SuspendUserRequest request,
  }) async {
    return _client.post(
      '${ApiEndpoints.practioners}/$userId/suspend',
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> reinstatePractioner({required int userId}) async {
    return _client.post('${ApiEndpoints.practioners}/$userId/reinstate');
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:respilink_mobile/core/constants/app_constants.dart';
import 'api_endpoints.dart';
import 'network_interceptor.dart';
import 'models/api_response.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.timeoutSeconds),
        receiveTimeout: Duration(seconds: AppConstants.timeoutSeconds),
        sendTimeout: Duration(seconds: AppConstants.timeoutSeconds),
        responseType: ResponseType.json,
      ),
    )..interceptors.addAll([NetworkInterceptor()]);
  }

  /// Call once in your DI setup (e.g. injection.dart or main.dart)
  static void init() {
    _instance ??= DioClient._internal();
  }

  static DioClient get instance {
    assert(_instance != null, 'DioClient.init() must be called first.');
    return _instance!;
  }

  // ─────────────────────────────────────────────
  // GET
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // POST
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // PUT
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // PATCH
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // MULTIPART / FORM-DATA (file upload)
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required FormData formData,
    T Function(dynamic)? fromJson,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    return _execute<T>(
      () => _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      ),
      fromJson,
    );
  }

  // ─────────────────────────────────────────────
  // Private executor — centralised error handling
  // ─────────────────────────────────────────────
  Future<ApiResponse<T>> _execute<T>(
    Future<Response> Function() request,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await request();
      final body = response.data;

      // If server wraps in {success, data, message} envelope:
      if (body is Map<String, dynamic> && body.containsKey('success')) {
        debugPrint("Raw response body: $body");
        return ApiResponse.fromJson(body, fromJson);
      }

      // Bare response (just the data object):
      debugPrint("Raw response body: $body");
      return ApiResponse.success(
        statusCode: response.statusCode,
        data: fromJson != null ? fromJson(body) : body as T?,
        token: (body is Map<String, dynamic>) ? body['token'] as String? : null,
      );
    } on DioException catch (e) {
      debugPrint("error aygya ${e.response?.data}");
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.failure(message: 'Unexpected error: $e');
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse.failure(
          statusCode: 408,
          message: 'Request timed out. Please check your connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final body = e.response?.data;
        final message =
            (body is Map ? body['message'] : null) ??
            _defaultMessageForStatus(statusCode);
        return ApiResponse.failure(
          statusCode: statusCode,
          message: message,
          errors: body is Map ? body['errors'] : null,
        );
      case DioExceptionType.cancel:
        return ApiResponse.failure(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return ApiResponse.failure(
          statusCode: 503,
          message: 'No internet connection.',
        );
      default:
        return ApiResponse.failure(
          message: e.message ?? e.error?.toString() ?? 'Unknown network error.',
        );
    }
  }

  String _defaultMessageForStatus(int? code) => switch (code) {
    400 => 'Bad request.',
    401 => 'Unauthorised. Please log in again.',
    403 => 'Forbidden.',
    404 => 'Resource not found.',
    422 => 'Validation failed.',
    429 => 'Too many requests. Slow down.',
    500 => 'Internal server error.',
    502 => 'Bad gateway.',
    503 => 'Service unavailable.',
    _ => 'Something went wrong (HTTP $code).',
  };
}

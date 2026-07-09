import 'package:dio/dio.dart';
import 'package:respilink_app/core/constants/app_constants.dart';

class NetworkInterceptor extends Interceptor {
  final Future<String?> Function()? onRefreshToken;

  NetworkInterceptor({
    this.onRefreshToken,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppConstants.apiToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;
    if (responseData is Map && responseData['data'] != null) {
      final nestedData = responseData['data'];
      if (nestedData is Map && nestedData.containsKey('token')) {
        AppConstants.apiToken = nestedData['token'] ?? '';
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

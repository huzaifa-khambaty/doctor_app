import 'package:dio/dio.dart';
import 'package:respilink_mobile/core/constants/app_constants.dart';

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
    options.contentType = 'application/json';

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;
    if (responseData is Map) {
      // The token may be at the top level or nested under `data` — check both.
      final topLevelToken = responseData['token'];
      if (topLevelToken is String) {
        AppConstants.apiToken = topLevelToken;
      } else if (responseData['data'] is Map) {
        final nestedData = responseData['data'] as Map;
        if (nestedData['token'] is String) {
          AppConstants.apiToken = nestedData['token'] as String;
        }
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

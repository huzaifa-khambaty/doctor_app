import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  final Map<String, _CacheEntry> _cache = {};
  final Duration maxAge;

  CacheInterceptor({this.maxAge = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // If not a GET request, clear cache to ensure freshness after mutations
    if (options.method.toUpperCase() != 'GET') {
      _cache.clear();
      return handler.next(options);
    }

    // For GET requests, check cache
    final key = options.uri.toString();
    final entry = _cache[key];

    if (entry != null && DateTime.now().difference(entry.timestamp) < maxAge) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: entry.data,
          statusCode: 200,
          statusMessage: 'OK (Cached)',
        ),
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cache successful GET responses
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final key = response.requestOptions.uri.toString();
      _cache[key] = _CacheEntry(
        data: response.data,
        timestamp: DateTime.now(),
      );
    }

    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If a GET request fails, try to serve from stale cache as a fallback
    if (err.requestOptions.method.toUpperCase() == 'GET') {
      final key = err.requestOptions.uri.toString();
      final entry = _cache[key];
      
      if (entry != null) {
        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: entry.data,
            statusCode: 200,
            statusMessage: 'OK (Stale Cache)',
          ),
        );
      }
    }
    handler.next(err);
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});
}

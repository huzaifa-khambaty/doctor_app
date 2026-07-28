import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/query_form/data/model/queries_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/requests/submit_query_request.dart';

import '../../../../core/network/models/api_response.dart';

abstract class QueryFormRemoteDataSource {
  Future<ApiResponse<List<QueryCategoryModel>>> getQueryCategories();

  Future<ApiResponse<void>> submitQuery(SubmitQueryRequest request);

  Future<ApiResponse<QueriesModel>> getQueries();
}

class QueryFormRemoteDataSourceImpl implements QueryFormRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<QueryCategoryModel>>> getQueryCategories() async {
    return _client.get(
      ApiEndpoints.queryCategories,
      fromJson: (json) {
        // Laravel resource collections wrap arrays as {"data": [...]},
        // but some endpoints in this API return a bare array — handle both.
        final list = json is List
            ? json
            : (json as Map<String, dynamic>)['data'] as List;
        return list
            .map((e) => QueryCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<ApiResponse<void>> submitQuery(SubmitQueryRequest request) async {
    return _client.post(ApiEndpoints.queries, data: request.toJson());
  }

  @override
  Future<ApiResponse<QueriesModel>> getQueries() async {
    return _client.get(
      ApiEndpoints.queries,
      fromJson: (json) => QueriesModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

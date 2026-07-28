import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/query_form/data/model/queries_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/requests/submit_query_request.dart';

abstract class QueryFormRepository {
  Future<ApiResponse<List<QueryCategoryModel>>> getQueryCategories();

  Future<ApiResponse<void>> submitQuery(SubmitQueryRequest request);

  Future<ApiResponse<QueriesModel>> getQueries();
}

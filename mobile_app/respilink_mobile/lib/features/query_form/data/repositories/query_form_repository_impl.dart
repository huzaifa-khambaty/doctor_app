import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/query_form/data/model/queries_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/requests/submit_query_request.dart';
import 'package:respilink_mobile/features/query_form/data/sources/query_form_remote_data_source.dart';
import 'package:respilink_mobile/features/query_form/domain/repositories/query_form_repository.dart';

class QueryFormRepositoryImpl implements QueryFormRepository {
  final QueryFormRemoteDataSource _remoteDataSource;

  QueryFormRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<QueryCategoryModel>>> getQueryCategories() {
    return _remoteDataSource.getQueryCategories();
  }

  @override
  Future<ApiResponse<void>> submitQuery(SubmitQueryRequest request) {
    return _remoteDataSource.submitQuery(request);
  }

  @override
  Future<ApiResponse<QueriesModel>> getQueries() {
    return _remoteDataSource.getQueries();
  }
}

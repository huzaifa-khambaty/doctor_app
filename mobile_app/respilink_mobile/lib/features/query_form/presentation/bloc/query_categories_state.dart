import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';

abstract class QueryCategoriesState {}

class QueryCategoriesLoading extends QueryCategoriesState {}

class QueryCategoriesLoaded extends QueryCategoriesState {
  final List<QueryCategoryModel> categories;

  QueryCategoriesLoaded({required this.categories});
}

class QueryCategoriesFailed extends QueryCategoriesState {
  final String message;

  QueryCategoriesFailed({required this.message});
}

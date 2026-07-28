import 'package:respilink_mobile/features/query_form/data/model/queries_model.dart';

abstract class RecentQueriesState {}

class RecentQueriesLoading extends RecentQueriesState {}

class RecentQueriesLoaded extends RecentQueriesState {
  final List<Data> queries;

  RecentQueriesLoaded({required this.queries});
}

class RecentQueriesFailed extends RecentQueriesState {
  final String message;

  RecentQueriesFailed({required this.message});
}

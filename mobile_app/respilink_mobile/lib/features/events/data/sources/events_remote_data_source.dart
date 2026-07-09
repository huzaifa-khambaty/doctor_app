import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';

import '../../../../core/network/models/api_response.dart';

abstract class EventsRemoteDataSource {
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  });
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  }) async {
    return _client.get(
      ApiEndpoints.events,
      queryParameters: {
        'page': page,
        if (type != null && type.isNotEmpty) 'type': type,
      },
      fromJson: (json) =>
          EventListingModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

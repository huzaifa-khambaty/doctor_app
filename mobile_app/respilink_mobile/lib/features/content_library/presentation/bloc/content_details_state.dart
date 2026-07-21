import 'package:respilink_mobile/features/content_library/data/models/content_details_model.dart';

abstract class ContentDetailsState {}

class ContentDetailsLoading extends ContentDetailsState {}

class ContentDetailsLoaded extends ContentDetailsState {
  final ContentDetailsModel details;

  ContentDetailsLoaded({required this.details});

  ContentDetailsLoaded copyWith({ContentDetailsModel? details}) {
    return ContentDetailsLoaded(details: details ?? this.details);
  }
}

class ContentDetailsFailed extends ContentDetailsState {
  final String message;

  ContentDetailsFailed({required this.message});
}

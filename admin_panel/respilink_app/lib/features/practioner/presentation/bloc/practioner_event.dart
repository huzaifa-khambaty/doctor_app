import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';

abstract class PractionerEvent {}

class FetchSpecialtiesRequested extends PractionerEvent {}

class FetchPractionersRequested extends PractionerEvent {
  final int page;
  final String? status;
  final int? specialtyId;

  FetchPractionersRequested({
    this.page = 1,
    this.status,
    this.specialtyId,
  });
}

class VerifyPractionerRequested extends PractionerEvent {
  final int userId;
  VerifyPractionerRequested(this.userId);
}

class RejectPractionerRequested extends PractionerEvent {
  final int userId;
  RejectPractionerRequested(this.userId);
}

class SuspendPractionerRequested extends PractionerEvent {
  final int userId;
  final SuspendUserRequest request;
  SuspendPractionerRequested({required this.userId, required this.request});
}

class ReinstatePractionerRequested extends PractionerEvent {
  final int userId;
  ReinstatePractionerRequested(this.userId);
}

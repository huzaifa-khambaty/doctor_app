import 'package:respilink_app/features/practioner/data/model/requests/create_practioner_request.dart';
import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class PractionerEvent {}

class CreatePractionerRequested extends PractionerEvent {
  final CreatePractionerRequest request;
  final PickedImage? photo;
  CreatePractionerRequested(this.request, {this.photo});
}

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
  final String? reason;
  RejectPractionerRequested(this.userId, {this.reason});
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

import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/data/model/specialities_model.dart';

class PractionerState {
  final List<SpecialitiesModel> specialties;
  final bool isLoadingSpecialties;

  final PractionersModel? practioners;
  final bool isLoadingPractioners;

  // Kept in state so pagination can reuse active filters when changing pages.
  final String? activeStatus;
  final int? activeSpecialtyId;

  // Action (verify / reject / suspend / reinstate) state.
  final bool isActionLoading;
  final int? actioningUserId;

  final bool isCreating;
  final bool createSuccess;
  final String? error;
  final bool actionSuccess;

  // Dashboard stats — fetched independently so they don't interfere with the table.
  final int? pendingTotal;
  final int? verifiedTotal;

  const PractionerState({
    this.specialties = const [],
    this.isLoadingSpecialties = false,
    this.practioners,
    this.isLoadingPractioners = false,
    this.activeStatus,
    this.activeSpecialtyId,
    this.isActionLoading = false,
    this.actioningUserId,
    this.isCreating = false,
    this.createSuccess = false,
    this.error,
    this.actionSuccess = false,
    this.pendingTotal,
    this.verifiedTotal,
  });

  PractionerState copyWith({
    List<SpecialitiesModel>? specialties,
    bool? isLoadingSpecialties,
    PractionersModel? practioners,
    bool? isLoadingPractioners,
    String? activeStatus,
    int? activeSpecialtyId,
    bool? isActionLoading,
    int? actioningUserId,
    bool? isCreating,
    bool? createSuccess,
    String? error,
    bool? actionSuccess,
    bool clearStatus = false,
    bool clearSpecialtyId = false,
    bool clearActioningUserId = false,
    int? pendingTotal,
    int? verifiedTotal,
  }) {
    return PractionerState(
      specialties: specialties ?? this.specialties,
      isLoadingSpecialties: isLoadingSpecialties ?? this.isLoadingSpecialties,
      practioners: practioners ?? this.practioners,
      isLoadingPractioners: isLoadingPractioners ?? this.isLoadingPractioners,
      activeStatus: clearStatus ? null : (activeStatus ?? this.activeStatus),
      activeSpecialtyId: clearSpecialtyId ? null : (activeSpecialtyId ?? this.activeSpecialtyId),
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actioningUserId: clearActioningUserId ? null : (actioningUserId ?? this.actioningUserId),
      isCreating: isCreating ?? this.isCreating,
      createSuccess: createSuccess ?? false,
      error: error,
      actionSuccess: actionSuccess ?? false,
      pendingTotal: pendingTotal ?? this.pendingTotal,
      verifiedTotal: verifiedTotal ?? this.verifiedTotal,
    );
  }
}

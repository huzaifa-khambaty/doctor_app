class NotificationState {
  final bool isSubmitting;
  final bool submitSuccess;
  final String? error;
  final int? verifiedDoctorsCount;
  final bool isLoadingCount;

  const NotificationState({
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.error,
    this.verifiedDoctorsCount,
    this.isLoadingCount = false,
  });

  NotificationState copyWith({
    bool? isSubmitting,
    bool? submitSuccess,
    String? error,
    int? verifiedDoctorsCount,
    bool? isLoadingCount,
  }) {
    return NotificationState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? false,
      error: error,
      verifiedDoctorsCount: verifiedDoctorsCount ?? this.verifiedDoctorsCount,
      isLoadingCount: isLoadingCount ?? this.isLoadingCount,
    );
  }
}

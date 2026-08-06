import 'package:respilink_app/features/query/data/model/all_notifications_model.dart';

class NotificationState {
  final Notifications? notifications;
  final bool isLoadingNotifications;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? error;
  final int? verifiedDoctorsCount;
  final bool isLoadingCount;
  final bool isActionLoading;
  final bool actionSuccess;
  final String? actionMessage;

  const NotificationState({
    this.notifications,
    this.isLoadingNotifications = false,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.error,
    this.verifiedDoctorsCount,
    this.isLoadingCount = false,
    this.isActionLoading = false,
    this.actionSuccess = false,
    this.actionMessage,
  });

  NotificationState copyWith({
    Notifications? notifications,
    bool? isLoadingNotifications,
    bool? isSubmitting,
    bool? submitSuccess,
    String? error,
    int? verifiedDoctorsCount,
    bool? isLoadingCount,
    bool? isActionLoading,
    bool? actionSuccess,
    String? actionMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoadingNotifications: isLoadingNotifications ?? this.isLoadingNotifications,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? false,
      error: error,
      verifiedDoctorsCount: verifiedDoctorsCount ?? this.verifiedDoctorsCount,
      isLoadingCount: isLoadingCount ?? this.isLoadingCount,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionSuccess: actionSuccess ?? false,
      actionMessage: actionMessage,
    );
  }
}

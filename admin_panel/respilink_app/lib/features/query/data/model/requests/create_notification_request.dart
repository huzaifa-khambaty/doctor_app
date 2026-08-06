class CreateNotificationRequest {
  final String title;
  final String message;
  final String audienceSegment;
  final String? scheduleAt;
  final String status;

  const CreateNotificationRequest({
    required this.title,
    required this.message,
    required this.audienceSegment,
    this.scheduleAt,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'audience_segment': audienceSegment,
        'schedule_at': scheduleAt,
        'status': status,
      };
}

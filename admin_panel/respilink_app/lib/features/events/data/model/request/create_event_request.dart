class CreateEventRequest {
  String title;
  String type;
  List<int> speakers;
  String startsAt;
  String endsAt;
  String timezone;
  String location;
  String description;
  String? externalJoinLink;
  String? recordingLink;
  bool enableQaSession;
  bool certificateOfParticipation;
  bool sendEmailReminders;

  CreateEventRequest({
    required this.title,
    required this.type,
    required this.speakers,
    required this.startsAt,
    required this.endsAt,
    required this.timezone,
    required this.location,
    required this.description,
    this.externalJoinLink,
    this.recordingLink,
    required this.enableQaSession,
    required this.certificateOfParticipation,
    required this.sendEmailReminders,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'speakers': speakers,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'timezone': timezone,
      'location': location,
      'description': description,
      if (externalJoinLink != null) 'external_join_link': externalJoinLink,
      if (recordingLink != null) 'recording_link': recordingLink,
      'enable_qa_session': enableQaSession,
      'certificate_of_participation': certificateOfParticipation,
      'send_email_reminders': sendEmailReminders,
    };
  }
}

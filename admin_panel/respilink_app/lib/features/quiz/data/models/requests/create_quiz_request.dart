class CreateQuizRequest {
  final String title;
  final String? description;
  final String? opensAt;
  final String? closesAt;
  final int? timeLimitMinutes;
  final int? topic;

  const CreateQuizRequest({
    required this.title,
    this.description,
    this.opensAt,
    this.closesAt,
    this.timeLimitMinutes,
    this.topic,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null && description!.isNotEmpty)
          'description': description,
        if (opensAt != null) 'opens_at': opensAt,
        if (closesAt != null) 'closes_at': closesAt,
        if (timeLimitMinutes != null) 'time_limit_minutes': timeLimitMinutes,
        if (topic != null) 'topic_id': topic,
      };
}

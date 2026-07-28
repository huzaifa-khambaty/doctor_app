class SubmitQueryRequest {
  final int categoryId;
  final String subject;
  final String message;

  SubmitQueryRequest({
    required this.categoryId,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subject': subject,
      'message': message,
    };
  }
}

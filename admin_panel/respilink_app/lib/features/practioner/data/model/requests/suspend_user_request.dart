class SuspendUserRequest {
  final String reason;

  SuspendUserRequest({
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
    };
  }
}
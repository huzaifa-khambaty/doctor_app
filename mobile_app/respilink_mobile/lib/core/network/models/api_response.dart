import 'package:respilink_mobile/shared/models/pagination_model.dart';

class ApiResponse<T> {
  final bool success;
  final int? statusCode;
  final String? message;
  final T? data;
  final dynamic errors;
  final String? token;
  final Pagination? pagination;

  /// Set when the backend blocks an otherwise-valid request because the
  /// account's email/phone isn't OTP-verified yet (e.g. login before
  /// completing signup verification) — [otpIdentifier] is who the OTP
  /// should be (re)sent to.
  final bool requiresOtp;
  final String? otpIdentifier;

  const ApiResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
    this.errors,
    this.token,
    this.pagination,
    this.requiresOtp = false,
    this.otpIdentifier,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    Pagination? pagination;
    if (json['meta'] is Map<String, dynamic>) {
      final meta = json['meta'] as Map<String, dynamic>;
      if (meta['pagination'] is Map<String, dynamic>) {
        pagination = Pagination.fromJson(meta['pagination']);
      }
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'],
      // The token may be at the top level (e.g. Laravel Sanctum-style
      // {success, token, data: {...}}) or nested under `data` — check both.
      token:
          json['token'] as String? ??
          ((json['data'] is Map<String, dynamic>)
              ? json['data']['token'] as String?
              : null),
      pagination: pagination,
      requiresOtp: json['requires_otp'] == true,
      otpIdentifier: json['identifier'] as String?,
    );
  }

  factory ApiResponse.success({
    int? statusCode,
    String? message,
    T? data,
    String? token,
  }) {
    return ApiResponse<T>(
      success: true,
      statusCode: statusCode,
      message: message,
      data: data,
      token: token,
    );
  }

  factory ApiResponse.failure({
    int? statusCode,
    String? message,
    dynamic errors,
    bool requiresOtp = false,
    String? otpIdentifier,
  }) {
    return ApiResponse<T>(
      success: false,
      statusCode: statusCode,
      message: message,
      errors: errors,
      requiresOtp: requiresOtp,
      otpIdentifier: otpIdentifier,
    );
  }

  String get fullErrorMessage {
    // If there's a top-level message but no specific errors, return it
    if (errors == null || errors is! Map) {
      return message ?? "An unknown error occurred.";
    }

    final errorMap = errors as Map<String, dynamic>;
    List<String> allErrors = [];

    errorMap.forEach((key, value) {
      if (value is List) {
        allErrors.addAll(value.map((e) => e.toString()));
      } else {
        allErrors.add(value.toString());
      }
    });

    return allErrors.isNotEmpty
        ? allErrors.join(
            "\n",
          ) // Use "\n" for multi-line or ", " for a single line
        : (message ?? "An unknown error occurred.");
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, statusCode: $statusCode, message: $message, data: $data)';
}

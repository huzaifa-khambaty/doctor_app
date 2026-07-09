class ApiEndpoints {
  ApiEndpoints._();

  // Base Url
  static const String baseUrl = 'http://192.168.100.115:8000/api/admin/v1';

  static const String imageUrl = "http://192.168.100.115:8000/storage/";
  static const String documentUrl = "http://192.168.100.115.100:8000";

  /// Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profilePicture = '/profile/photo';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String editProfile = '/profile';
  static const String me = '/auth/me';

  /// Practitioner
  static const String specialties = '/specialties';
  static const String practioners = '/users';

    /// Events
  static const String events = '/events';
}
class ApiEndpoints {
  ApiEndpoints._();

  // Base Url
  // static const String baseUrl = 'http://192.168.100.115:8000/api/v1';

  // static const String imageUrl = "http://192.168.100.115:8000/storage/";
  
  static const String baseUrl = 'https://doctorapp.bharmalsystems.net/api/v1';

  static const String imageUrl = "https://doctorapp.bharmalsystems.net/storage/";

  /// Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String resendOtp = '/auth/otp/send';
  static const String otpVerify = '/auth/otp/verify';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String editProfile = '/profile';
  static const String me = '/auth/me';

  /// Practitioner
  static const String specialties = '/specialties';
  static const String practioners = '/users';

  /// Events
  static const String events = '/events';

  ///Quiz
  static const String quizHome = '/quizzes/home';
  static const String categoryQuiz = '/topics';
  static const String quizzes = '/quizzes';
  static const String badges = '/badges/overview';

  //Content
  static const String library = '/library';

  ///Home
  static const String home = '/home';
}

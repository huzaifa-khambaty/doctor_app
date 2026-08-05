class AppSettingsModel {
  final int? id;
  final String? appName;
  final String? appEmail;
  final String? appLogo;
  final String? timeZone;
  final String? language;

  const AppSettingsModel({
    this.id,
    this.appName,
    this.appEmail,
    this.appLogo,
    this.timeZone,
    this.language,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      id: json['id'] as int?,
      appName: json['app_name'] as String?,
      appEmail: json['app_email'] as String?,
      appLogo: json['app_logo'] as String?,
      timeZone: json['time_zone'] as String?,
      language: json['language'] as String?,
    );
  }
}

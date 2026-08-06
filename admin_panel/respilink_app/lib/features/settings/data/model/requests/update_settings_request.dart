import 'dart:typed_data';

class UpdateSettingsRequest {
  final String? appName;
  final String? appEmail;
  final String? timeZone;
  final String? language;
  final Uint8List? logoBytes;
  final String? logoName;

  const UpdateSettingsRequest({
    this.appName,
    this.appEmail,
    this.timeZone,
    this.language,
    this.logoBytes,
    this.logoName,
  });

  Map<String, dynamic> toJson() => {
        if (appName != null) 'app_name': appName,
        if (appEmail != null) 'app_email': appEmail,
        if (timeZone != null) 'time_zone': timeZone,
        if (language != null) 'language': language,
        '_method': 'PUT', // Indicate that this is an update operation
      };
}

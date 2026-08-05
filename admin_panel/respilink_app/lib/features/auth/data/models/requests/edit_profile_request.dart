import 'dart:typed_data';

class EditProfileRequest {
  final String name;
  final String email;
  final Uint8List? photoBytes;
  final String? photoName;

  const EditProfileRequest({
    required this.name,
    required this.email,
    this.photoBytes,
    this.photoName,
  });
}

class ProfilePhotoUpdate {
  final String? profilePhoto;
  ProfilePhotoUpdate({this.profilePhoto});

  factory ProfilePhotoUpdate.fromJson(Map<String, dynamic> json) {
    return ProfilePhotoUpdate(profilePhoto: json['profile_photo']);
  }
}
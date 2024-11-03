class ProfileModel {

  
  String imageUser;

  ProfileModel({this.imageUser = ''});

  Map<String, dynamic> toMap() {
    return {
      'image_user': imageUser,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      imageUser: map['image_user'] ?? '',
    );
  }
}



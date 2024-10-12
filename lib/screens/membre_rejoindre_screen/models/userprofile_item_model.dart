class UserprofileItemModel {
  String? userImage;
  String? username;

  UserprofileItemModel({this.userImage, this.username});

  factory UserprofileItemModel.fromJson(Map<String, dynamic> json) {
    return UserprofileItemModel(
      userImage: json['userImage'],
      username: json['username'],
    );
  }
}

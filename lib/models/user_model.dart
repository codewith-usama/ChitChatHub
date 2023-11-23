class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? profilePicUrl;

  UserModel({
    this.email,
    this.uid,
    this.fullName,
    this.profilePicUrl,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullName = map['full_name'];
    email = map['email'];
    profilePicUrl = map['profile_pic_url'];
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'full_name': fullName,
        'email': email,
        'profile_pic_url': profilePicUrl,
      };
}

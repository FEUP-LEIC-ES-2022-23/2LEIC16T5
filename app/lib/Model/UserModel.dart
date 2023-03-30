class UserModel {
  String? uid;
  UserModel({required this.uid});
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
      );

  Map<String, dynamic> toMap() {
    return {'uid': uid};
  }
}

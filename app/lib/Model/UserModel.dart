class UserModel {
  String? uid;
  UserModel({required this.uid});
  
  Map<String, dynamic> toMap() {
    return {
      'uid':uid
    };
  }
}

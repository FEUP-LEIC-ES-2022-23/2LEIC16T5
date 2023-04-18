import 'package:es/Model/UserModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  UserModel object = UserModel(uid: '1');
  Map<String,dynamic> json = {'uid':'1'};

  test('Deserialize from JSON', (){
    UserModel temp = UserModel.fromMap(json);
    expect(temp.uid, json['uid']);
  });

  test('Serialize to JSON', (){
    Map<String,dynamic> tmp = object.toMap();
    expect(tmp['uid'], json['uid']);
  });
}
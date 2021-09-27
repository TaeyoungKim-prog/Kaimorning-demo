import 'package:cloud_firestore/cloud_firestore.dart';
import '../constant/firestore_keys.dart';

class UserModel{

  final String userKey;
  final String userNickname;
  final String userDest;
  final String userPhone;

  final DocumentReference reference;

  UserModel.fromMap(Map<String, dynamic> map, {this.reference})
      : userKey = map[KEY_USERKEY],
        userNickname = map[KEY_USERNICKNAME],
        userDest = map[KEY_USERDEST],
        userPhone = map[KEY_USERPHONE];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateUser({
    String userKey,
    String userNickname,
    String userDest,
    String userPhone
  }){
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNICKNAME] = userNickname;
    map[KEY_USERDEST] = userDest;
    map[KEY_USERPHONE] = userPhone;


    return map;
  }

}
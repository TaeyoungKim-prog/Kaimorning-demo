import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/firestore_keys.dart';
import '../model/rider_model.dart';
import 'help/transformer.dart';



class UserNetwork with Transformers {

  Future<void> createNewUser({@required String userKey, @required String userNickName, @required String userDest, @required String userPhone}) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot = await userRef.get();

    if(!snapshot.exists){
    return await userRef.set(UserModel.getMapForCreateUser(userKey: userKey, userNickname: userNickName, userDest: userDest, userPhone: userPhone));
    }
  }

  Future<void> updateUser({@required String userKey, @required String userPhone, @required String userDest}) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_USERS).doc(userKey);


    return await userRef.update({KEY_USERPHONE: userPhone, KEY_USERDEST: userDest});
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<RiderModel> getRiderModelStream(String userKey) {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_RIDERS)
        .doc(userKey)
        .snapshots()
        .transform(toRider);
  }

  Stream<List<UserModel>> getUsers() {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsers);
  }



}

UserNetwork userNetwork = UserNetwork();
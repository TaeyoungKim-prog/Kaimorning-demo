import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/firestore_keys.dart';
import '../model/rider_model.dart';
import 'help/transformer.dart';

class StoreNetwork with Transformers {
  // @required List<String> storeItem 이건 뺀다. 처음 등록할때는 메뉴 추가 ㄴㄴㄴ
  Future<void> createNewStore(
      {@required String storeKey,
      @required String storeName,
      @required String storePhone,
      @required double lat,
      @required double lon}) async {
    final DocumentReference storeRef = FirebaseFirestore.instance
        .collection(COLLECTION_HOME)
        .doc(DOCUMENT_ASSET)
        .collection(COLLECTION_STORES)
        .doc(storeKey);

    DocumentSnapshot snapshot = await storeRef.get();
    int priorityNum = await storeNetwork.getStoresPriority().then((value) => value.length);
    final DocumentReference priorityRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ASSET).collection(COLLECTION_STORES).doc(KEY_PRIORITY);

    if (!snapshot.exists) {

      return FirebaseFirestore.instance.runTransaction((Transaction tx) async {

        await tx.set(storeRef, StoreModel.getMapForCreateStore(
            storeKey: storeKey,
            storeName: storeName,
            storePhone: storePhone,
            storeItem: [],
            // 처음엔 빈 아이템들
            lat: lat,
            lon: lon,
            priority: priorityNum + 1
        ));

        await tx.update(priorityRef, {KEY_PRIORITY: FieldValue.arrayUnion([storeKey])});

      });




    }
  }

  Future<void> updateStoreInfo(
      @required String storeKey,
      @required String storePhone,
      @required double lat,
      @required double lon,
      @required List<dynamic> storeItem) async {
    final DocumentReference storeRef = FirebaseFirestore.instance
        .collection(COLLECTION_HOME)
        .doc(DOCUMENT_ASSET)
        .collection(COLLECTION_STORES)
        .doc(storeKey);

    return await storeRef.update({
      KEY_STOREPHONE: storePhone,
      KEY_LAT: lat,
      KEY_LON: lon,
      KEY_STOREITEM: storeItem,
      KEY_LASTUPDATE: DateTime.now()
    });
  }

  Future<void> updatePriority({List<dynamic> keys}) async {

    final CollectionReference storesRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ASSET).collection(COLLECTION_STORES);
    final DocumentReference priorityRef = storesRef.doc(KEY_PRIORITY);

    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      int index = 0;

      // priority 세팅
      await tx.set(priorityRef, {KEY_PRIORITY:keys});

      keys.forEach((element) async {
        index += 1;
        final storeRef = storesRef.doc(element);
        await tx.update(storeRef, {KEY_PRIORITY: index});
      });

    });

  }

  Stream<List<StoreModel>> getStores() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_HOME)
        .doc(DOCUMENT_ASSET)
        .collection(COLLECTION_STORES)
        .snapshots()
        .transform(toStores);
  }

  Stream<StoreModel> getStoreFromKey(dynamic storeKey) {
    if (storeKey == null){
      return null;
    }
    else{
      return FirebaseFirestore.instance
          .collection(COLLECTION_HOME)
          .doc(DOCUMENT_ASSET)
          .collection(COLLECTION_STORES)
          .doc(storeKey)
          .snapshots()
          .transform(toStore);
    }
  }

  Future<List<dynamic>> getStoresPriority() async {
    return await FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ASSET).collection(COLLECTION_STORES).doc(KEY_PRIORITY).get().then((value) => value[KEY_PRIORITY]);
  }

  Stream<List<StoreModel>> getStoresNoPriority() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_HOME)
        .doc(DOCUMENT_ASSET)
        .collection(COLLECTION_STORES)
        .snapshots()
        .transform(toStoresNoPriority);
  }


}

StoreNetwork storeNetwork = StoreNetwork();

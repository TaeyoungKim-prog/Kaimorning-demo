import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/firestore_keys.dart';
import 'help/transformer.dart';



class OrderNetwork with Transformers {

  Future<void> createNewOrder({
    @required String orderKey,
    @required String store,
    @required String menu,
    @required String time,
    @required String dest,
    @required String ordererKey,
    @required DateTime orderDay,
    @required int priority,
  }) async {
    final DocumentReference orderRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS).doc(orderKey);

    DocumentSnapshot snapshot = await orderRef.get();

    if(!snapshot.exists){
      return await orderRef.set(OrderModel.getMapForCreateOrder(
        orderKey: orderKey,
        store: store,
        menu: menu,
        time: time,
        dest: dest,
        ordererKey: ordererKey,
        orderDay: orderDay,
        priority: priority
      ));
    }
  }


  Stream<OrderModel> getRoomModelStream(String orderKey) {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .doc(orderKey)
        .snapshots()
        .transform(toOrder);
  }

  Stream<List<OrderModel>> getOrdersReady() {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toReadyOrder).transform(toPriorityStore);
  }

  Stream<List<OrderModel>> getOrdersDoing() {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toDoingOrder).transform(toPriorityDest);
  }

  Stream<List<OrderModel>> getOrdersDone() {
    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toDoneOrder);
  }

  Future<void> changeOrderProcess({@required String orderKey, @required String process}) async {

    final DocumentReference orderRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS).doc(orderKey);
    final DocumentSnapshot orderSnapshot = await orderRef.get();

    if(orderSnapshot.exists){
      switch(process){
        case KEY_READY:
          await orderRef.update({KEY_PROCESS: KEY_READY});
          break;

        case KEY_DOING:
          await orderRef.update({KEY_PROCESS: KEY_DOING});
          break;

        case KEY_DONE:
          await orderRef.update({KEY_PROCESS: KEY_DONE});
          break;

        default:
          break;
      }
    }
  }
}

OrderNetwork orderNetwork = OrderNetwork();
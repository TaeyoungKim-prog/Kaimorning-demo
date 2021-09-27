import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_kai_morning_210303/constant/firestore_keys.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import '../../model/rider_model.dart';


class Transformers {

  final toRider = StreamTransformer<DocumentSnapshot, RiderModel>.fromHandlers(
    handleData: (snapshot, sink) async {
      sink.add(RiderModel.fromSnapshot(snapshot));
    }
  );

  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
        sink.add(UserModel.fromSnapshot(snapshot));
      }
  );

  final toOrder = StreamTransformer<DocumentSnapshot, OrderModel>.fromHandlers(
      handleData: (snapshot, sink) async {
        sink.add(OrderModel.fromSnapshot(snapshot));
      }
  );

  final toReadyOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_READY)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });

  final toPriorityStore = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {

    //dreamStones.sort((a,b)=>b.recentUpdateTime.compareTo(a.recentUpdateTime));
    orders.sort((a,b) => a.priority.compareTo(b.priority));

    sink.add(orders);

  });

  final toPriorityDest = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {

    // n e w
    orders.sort((a,b) {
      String _a = a.dest[0];
      String _b = b.dest[0];

      if(_a != _b ){
        if(_a  == 'n')
          return 1;
        else if(_a  == 'e'){
          if(_b == 'n')
            return -1;
          else
            return 1;
        }
        else
          return -1;
      }
      else
        return 0;
    });

    sink.add(orders);

  });


  final toDoingOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_DOING)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });

  final toDoneOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_DONE)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });

  final toUsers = StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<UserModel> users = [];

    snapshot.docs.forEach((documentSnapshot) {
        users.add(UserModel.fromSnapshot(documentSnapshot));
    });

    sink.add(users);
  });

  final toStores = StreamTransformer<QuerySnapshot, List<StoreModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<StoreModel> stores = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.id != KEY_PRIORITY){
        stores.add(StoreModel.fromSnapshot(documentSnapshot));
      }
    });

    sink.add(stores);
  });


  final toStore = StreamTransformer<DocumentSnapshot, StoreModel>.fromHandlers(handleData: (snapshot, sink) async {
    sink.add(StoreModel.fromSnapshot(snapshot));
  });


  final toStoresNoPriority = StreamTransformer<QuerySnapshot, List<StoreModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<StoreModel> stores = [];

    snapshot.docs.forEach((documentSnapshot) {

      if(documentSnapshot.id != KEY_PRIORITY){
        if(documentSnapshot.data()[KEY_PRIORITY] == 0)
          stores.add(StoreModel.fromSnapshot(documentSnapshot));
      }

    });

    sink.add(stores);
  });

  final toKeys = StreamTransformer<DocumentSnapshot, List<dynamic>>.fromHandlers(handleData: (snapshot, sink) async {
    sink.add(snapshot.data()[KEY_PRIORITY]);
  });

}
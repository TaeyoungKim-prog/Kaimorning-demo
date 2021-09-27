

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_kai_morning_210303/constant/firestore_keys.dart';

class OrderModel{

  final String orderKey;
  final String store;
  final String menu; // 가격 or 메뉴
  final String time; // 8:30 ~ 9:30 , 11:00 ~ 12:00
  final String madeTime;
  final String dest; // 미르관 1층, N4 1층 , 스타트업빌리지 305
  final String process; // ready, doing, done
  final String ordererKey;
  final DateTime orderDay;
  final int priority;

  final DocumentReference reference;


  OrderModel.fromMap(Map<String, dynamic> map, {this.reference})
      : orderKey = map[KEY_ORDERKEY],
        store = map[KEY_ORDERSTORE],
        menu = map[KEY_ORDERMENU],
        time = map[KEY_ORDERTIME],
        madeTime = map[KEY_MADETIME],
        dest = map[KEY_ORDERDEST],
        process = map[KEY_PROCESS],
        ordererKey = map[KEY_ORDERERKEY],
        orderDay =  (map[KEY_ORDERDAY]as Timestamp).toDate(),
        priority = map[KEY_PRIORITY];

  OrderModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);



  static Map<String, dynamic> getMapForCreateOrder({
    String orderKey,
    String store,
    String menu,
    String time,
    String dest,
    String ordererKey,
    DateTime orderDay,
    int priority
  }){
    Map<String, dynamic> map = Map();

    DateTime now = DateTime.now();

    map[KEY_ORDERKEY] = orderKey;
    map[KEY_ORDERSTORE] = store;
    map[KEY_ORDERMENU] = menu;
    map[KEY_ORDERTIME] = time;
    map[KEY_MADETIME] = DateTime(now.year, now.month, now.day, now.hour, now.minute).toString();
    map[KEY_ORDERDEST] = dest;
    map[KEY_PROCESS] = 'ready';
    map[KEY_ORDERERKEY] = ordererKey;
    map[KEY_ORDERDAY] = orderDay;
    map[KEY_PRIORITY] = priority;

    return map;
  }

}
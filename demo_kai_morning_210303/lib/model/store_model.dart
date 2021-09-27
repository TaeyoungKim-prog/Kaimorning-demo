import 'package:cloud_firestore/cloud_firestore.dart';
import '../constant/firestore_keys.dart';

class StoreModel {
  final String storeKey;
  final String storeName;
  final String storePhone;
  final List<dynamic> storeItem; // 분명 string이겠지만, firebase에서 받아올때는 dynamic이므로 요렇게 설정해야함.
  final double lat;
  final double lon;
  final int priority;
  final DateTime lastUpdate;

  final DocumentReference reference;

  StoreModel.fromMap(Map<String, dynamic> map, {this.reference})
      : storeKey = map[KEY_STOREKEY],
        storeName = map[KEY_STORENAME],
        storePhone = map[KEY_STOREPHONE],
        storeItem = map[KEY_STOREITEM],
        lat = map[KEY_LAT],
        lon = map[KEY_LON],
        priority = map[KEY_PRIORITY],
        lastUpdate = map[KEY_LASTUPDATE] == null
            ? DateTime.now()
            : (map[KEY_LASTUPDATE] as Timestamp).toDate();

  StoreModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateStore(
      {
        String storeKey,
      String storeName,
        String storePhone,
      List<dynamic> storeItem,
      double lat,
      double lon,
      int priority
      }) {
    Map<String, dynamic> map = Map();

    map[KEY_STOREKEY] = storeKey;
    map[KEY_STORENAME] = storeName;
    map[KEY_STOREPHONE] = storePhone;
    map[KEY_STOREITEM] = storeItem;
    map[KEY_LAT] = lat;
    map[KEY_LON] = lon;
    map[KEY_PRIORITY] = priority;
    map[KEY_LASTUPDATE] = DateTime.now();

    return map;
  }
}

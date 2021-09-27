String generateOrderKey({String store}){
  return '${DateTime.now().millisecondsSinceEpoch.toString()}_${store}';
}

String generateStoreKey({String storeName}){
  return '${DateTime.now().millisecondsSinceEpoch.toString()}_${storeName}';
}

String generateUserKey({String userName}){
  return '${DateTime.now().millisecondsSinceEpoch.toString()}_${userName}';
}
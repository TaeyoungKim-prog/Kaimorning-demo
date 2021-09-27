import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuSelectDialog extends StatefulWidget {

  final String storeKey;
  final Function selMenu;
  final Function nextFunc;

  MenuSelectDialog({this.storeKey, this.selMenu, this.nextFunc});

  @override
  _MenuSelectDialogState createState() => _MenuSelectDialogState();
}

class _MenuSelectDialogState extends State<MenuSelectDialog> {

  TextEditingController _menuController = TextEditingController();

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: StreamProvider<StoreModel>.value(
          value: storeNetwork.getStoreFromKey(widget.storeKey),
          child: Consumer<StoreModel>(
            builder: (context, store, _){
              if (store == null){
                return Text('메뉴를 고를 수 없습니다.');
              }
              else if(store.storeItem.isEmpty){
                return Text('메뉴를 고를 수 없습니다.');
              }
              else{
                return SizedBox(
                  height: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${store.storeName}', style: TextStyle(fontSize: 20.0),),
                      SizedBox(height: 15.0,),
                      Container(
                        height: 250.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey)
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical:3.0, horizontal: 10.0),
                              child: InkWell(
                                onTap: (){
                                  widget.selMenu(store.storeItem[index]);
                                  Navigator.pop(context);
                                  widget.nextFunc();
                                },
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                      color: Colors.grey[50]),
                                  child: Center(child: Text('${store.storeItem[index]}', style: TextStyle(color: Colors.black87),)),
                                ),
                              ),
                            );
                          },
                          itemCount: store.storeItem.length,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
    );
  }
}

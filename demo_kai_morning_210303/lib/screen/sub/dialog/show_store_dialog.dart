import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowStoreDialog extends StatefulWidget {

  final StoreModel storeModel;

  ShowStoreDialog({this.storeModel});

  @override
  _ShowStoreDialogState createState() => _ShowStoreDialogState();
}

class _ShowStoreDialogState extends State<ShowStoreDialog> {

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _lonController = TextEditingController();

  List<dynamic> tempItem;

  @override
  void initState() {
    _phoneController.text = widget.storeModel.storePhone;
    _latController.text = widget.storeModel.lat.toString();
    _lonController.text = widget.storeModel.lon.toString();
    tempItem = widget.storeModel.storeItem;
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('${widget.storeModel.storeName}'),
        content: SizedBox(
          height: size.height * 0.6,
          width: size.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전화번호',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '전화번호'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '위도 (기능x)',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _latController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '위도'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '경도 (기능x)',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _lonController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '경도'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Text(
                      '메뉴',
                    ),
                    Text(' ${tempItem.length}', style: TextStyle(fontSize: 15.0 , color: Colors.red)),
                    Expanded(child: Container(),),
                    InkWell(
                      onTap: (){
                        setState(() {
                          tempItem.add('메뉴 ${tempItem.length + 1}');
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: Colors.lightBlue)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('메뉴 추가',  style: TextStyle(fontSize: 12.0 , color: Colors.lightBlue)),
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey)
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:3.0, horizontal: 10.0),
                        child: InkWell(
                          onLongPress: () async {
                            await showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text('삭제하시겠습니까?'),
                                content: Text('${tempItem[index]}'),
                                actions: [
                                  FlatButton(
                                    child: Text('네', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    onPressed: (){
                                      tempItem.removeAt(index);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('아니요', style: TextStyle(color: Colors.black87)),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          },
                          onTap: () async {
                            await showDialog(context: context,
                            builder: (context){
                              TextEditingController _menuController = TextEditingController();
                              _menuController.text = tempItem[index];
                              return AlertDialog(
                                title: Text('메뉴 이름 설정'),
                                content: TextField(
                                  controller: _menuController,
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text('설정', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                    onPressed: (){
                                      tempItem[index] = _menuController.text;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('취소', style: TextStyle(color: Colors.black87)),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          },
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.grey[50]),
                            child: Center(child: Text('${tempItem[index]}', style: TextStyle(color: Colors.black87),)),
                          ),
                        ),
                      );
                    },
                    itemCount: tempItem.length,
                  ),
                )
              ],
            ),
          )
        ),
    actions: [
      FlatButton(
        onPressed: () async {
          await storeNetwork.updateStoreInfo(widget.storeModel.storeKey, _phoneController.text, widget.storeModel.lat, widget.storeModel.lon, tempItem);
          Navigator.pop(context);
        },
        child: Text('업데이트', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
    ),
      FlatButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text('취소', style: TextStyle(color: Colors.black87),),
      ),

      ],
    );
  }
}

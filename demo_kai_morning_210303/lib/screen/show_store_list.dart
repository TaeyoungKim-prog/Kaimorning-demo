import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:demo_kai_morning_210303/screen/sub/dialog/show_store_dialog.dart';
import 'package:demo_kai_morning_210303/screen/sub/set_store_priority.dart';
import 'package:demo_kai_morning_210303/useful/generate_key.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:demo_kai_morning_210303/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowStoreList extends StatefulWidget {
  @override
  _ShowStoreListState createState() => _ShowStoreListState();
}

class _ShowStoreListState extends State<ShowStoreList> {
  
  TextEditingController _searchController = TextEditingController();

  String number = '...';

  @override
  void initState() {
    super.initState();
    _initNumber();
  }

  void _initNumber() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('가게들', style: TextStyle(fontSize: 20.0),),
                      ),
                      Text(number,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 15.0))
                    ],
                  ),
                  Positioned(
                    top: 10.0,
                      right: 10.0,
                      child: InkWell(
                          onTap: ()async{
                            List<dynamic> initKeys = await storeNetwork.getStoresPriority();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SetStorePriority(initKeys:initKeys)));
                          },
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('픽업 순위'),
                      )))
                ],
              ),
            ),
            _searchBox(context),
            StreamProvider<List<StoreModel>>.value(
              value: storeNetwork.getStores(),
              child: Consumer<List<StoreModel>>(
                builder: (context, stores, _){
                  if(stores == null){
                    return MyProgressIndicator();
                  }
                  else if (stores.isEmpty){
                    return Text('가게가 없습니다.');
                  }
                  else{
                    number = stores.length.toString();

                    return Expanded(
                      child: ListView.builder(
                        itemCount: stores.length,
                        itemBuilder: (context, index){

                          bool _isSearchContain = SearchEngine.isContainSuchContent(base: stores[index].storeName, key:_searchController.text );

                          if (_searchController.text == null || _searchController.text == '' || _isSearchContain){
                            return InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ShowStoreDialog(storeModel: stores[index]);
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 130.0,
                                      width: size.width*0.9,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                          color: Colors.grey[50],
                                          border: Border.all(width: 1.0, color: Colors.grey)
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              stores[index].storeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                            ),
                                            SizedBox(height: 10.0,),
                                            Text('전화번호 : ${stores[index].storePhone}'),
                                            Text('메뉴 : ${stores[index].storeItem}'),
                                            Text('최근 수정 : ${stores[index].lastUpdate}')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 3),
                                ],
                              ),
                            );
                          }
                          else{
                            return Container();
                          }


                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (_){
                      setState(() {});
                    },
                    style: TextStyle(color: Colors.black),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.lightBlueAccent,
                    controller: _searchController,
                    decoration: new InputDecoration(
                        icon:Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "검색"),
                  ),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nameController = TextEditingController();
                  TextEditingController _phoneController = TextEditingController();
                  
                  return AlertDialog(
                    title: Text("가게 추가"),
                    content: SizedBox(
                      height: 160.0,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이름 (필수)', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5.0,),
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.grey[100]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: TextField(
                                  autofocus: true,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '가게 이름'),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Text('번호', style: TextStyle(color: Colors.black87),),
                            SizedBox(height: 5.0,),
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.grey[100]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '가게 번호'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "추가",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await storeNetwork.createNewStore(storeKey: generateStoreKey(storeName:_nameController.text), storeName: _nameController.text, storePhone: _phoneController.text, lat: 36.3737298, lon: 127.3590254);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "취소",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(width: 1.0, color: Colors.blue)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('추가', style: TextStyle(color: Colors.blue, fontSize: 15.0)),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }
}

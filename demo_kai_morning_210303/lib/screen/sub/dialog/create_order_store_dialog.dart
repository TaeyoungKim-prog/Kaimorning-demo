import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreSelectDialog extends StatefulWidget {

  final Function selStoreAndPriority;
  final Function nextFunc;

  StoreSelectDialog({this.selStoreAndPriority, this.nextFunc});

  @override
  _StoreSelectDialogState createState() => _StoreSelectDialogState();
}

class _StoreSelectDialogState extends State<StoreSelectDialog> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('가게 선택'),
        content: SizedBox(
          height: size.height * 0.6,
          width: size.width * 0.6,
          child: Column(
            children: [
              Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (_) {
                        setState((){});
                      },
                      style: TextStyle(color: Colors.black),
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Colors.lightBlueAccent,
                      controller: _searchController,
                      decoration: new InputDecoration(
                          icon: Icon(
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
              StreamProvider<List<StoreModel>>.value(
                value: storeNetwork.getStores(),
                child: Consumer<List<StoreModel>>(
                  builder: (context, stores, _) {
                    if (stores == null) {
                      return MyProgressIndicator();
                    } else if (stores.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('가게가 하나도 없어요!'),
                        ),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          bool _isSearchContain =
                              SearchEngine.isContainSuchContent(
                                  base: stores[index].storeName,
                                  key: _searchController.text);

                          if (_searchController.text == null ||
                              _searchController.text == '' ||
                              _isSearchContain) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  widget.selStoreAndPriority(stores[index].storeName, stores[index].priority, stores[index].storeKey);
                                  Navigator.pop(context);
                                  widget.nextFunc();
                                },
                                child: Container(
                                    height: 50.0,
                                    width: size.width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                        border: Border.all(
                                            width: 1.0, color: Colors.grey)),
                                    child: Center(
                                        child:
                                            Text('${stores[index].storeName}'))),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ));
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}

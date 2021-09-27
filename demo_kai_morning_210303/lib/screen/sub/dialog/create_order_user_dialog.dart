import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSelectDialog extends StatefulWidget {

  final Function selUser;
  final Function nextFunc;

  UserSelectDialog({this.selUser, this.nextFunc});

  @override
  _UserSelectDialogState createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('유저 선택'),
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
              StreamProvider<List<UserModel>>.value(
                value: userNetwork.getUsers(),
                child: Consumer<List<UserModel>>(
                  builder: (context, users, _) {
                    if (users == null) {
                      return MyProgressIndicator();
                    } else if (users.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('고객이 한명도 없어요!'),
                        ),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              bool _isSearchContain =
                              SearchEngine.isContainSuchContent(
                                  base: users[index].userNickname,
                                  key: _searchController.text) || SearchEngine.isContainSuchContent(
                                  base: users[index].userPhone,
                                  key: _searchController.text)|| SearchEngine.isContainSuchContent(base: users[index].userDest, key:_searchController.text ) ;

                              if (_searchController.text == null ||
                                  _searchController.text == '' ||
                                  _isSearchContain) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      widget.selUser(users[index].userKey, users[index].userNickname, defaultDest: users[index].userDest);
                                      Navigator.pop(context);
                                      widget.nextFunc();
                                    },
                                    child: Container(
                                        width: size.width * 0.8,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            border: Border.all(
                                                width: 1.0, color: Colors.grey)),
                                        child: Center(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('${users[index].userNickname}\n${users[index].userPhone}\n${users[index].userDest}'),
                                            ))),
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

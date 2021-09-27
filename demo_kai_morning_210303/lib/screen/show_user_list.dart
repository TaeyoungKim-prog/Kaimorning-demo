import 'dart:async';

import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:demo_kai_morning_210303/screen/sub/dialog/show_user_dialog.dart';
import 'package:demo_kai_morning_210303/useful/generate_key.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:demo_kai_morning_210303/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUserList extends StatefulWidget {
  @override
  _ShowUserListState createState() => _ShowUserListState();
}

class _ShowUserListState extends State<ShowUserList> {
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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '구독자분들',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text(number,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15.0))
                ],
              ),
            ),
            _searchBox(context),
            StreamProvider<List<UserModel>>.value(
              value: userNetwork.getUsers(),
              child: Consumer<List<UserModel>>(
                builder: (context, users, _) {
                  if (users == null) {
                    return MyProgressIndicator();
                  } else if (users.isEmpty) {
                    return Text('구독자가 없습니다.');
                  } else {
                    number = users.length.toString();

                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          bool _isSearchContain =
                              SearchEngine.isContainSuchContent(
                                      base: users[index].userNickname,
                                      key: _searchController.text) ||
                                  SearchEngine.isContainSuchContent(
                                      base: users[index].userPhone,
                                      key: _searchController.text) ||
                                  SearchEngine.isContainSuchContent(
                                      base: users[index].userDest,
                                      key: _searchController.text);

                          if (_searchController.text == null ||
                              _searchController.text == '' ||
                              _isSearchContain) {
                            return InkWell(
                              onLongPress: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                  return ShowUserDialog(userModel: users[index]);
                                },
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100.0,
                                      width: size.width * 0.9,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.grey[50],
                                          border: Border.all(
                                              width: 1.0, color: Colors.grey)),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              users[index].userNickname,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                                '전화번호 : ${users[index].userPhone}'),
                                            Text(
                                                '수령지 : ${users[index].userDest}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 3),
                                ],
                              ),
                            );
                          } else {
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
                    onChanged: (_) {
                      setState(() {});
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nameController =
                      TextEditingController();
                  TextEditingController _phoneController =
                      TextEditingController();
                  TextEditingController _destController =
                      TextEditingController();

                  return AlertDialog(
                    title: Text("고객 추가"),
                    content: SizedBox(
                      height: 280.0,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '닉네임 (필수)',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
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
                                  autofocus: true,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '고객 닉네임'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '번호 (필수)',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
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
                                      hintText: '고객 번호(10~11자리)'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '수령 장소',
                              style: TextStyle(color: Colors.black87),
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
                                  controller: _destController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '수령 장소'),
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
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (_nameController.text.length > 0 &&
                              (_phoneController.text.length == 10 ||
                                  _phoneController.text.length == 11)) {
                            await userNetwork.createNewUser(
                                userKey: generateUserKey(
                                    userName: _nameController.text),
                                userNickName: _nameController.text,
                                userDest: _destController.text,
                                userPhone: _phoneController.text);
                            Navigator.pop(context);
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return Center(
                                      child: Text(
                                          '등록 형태가 올바르지 않습니다\n\n1. 닉네임은 최소 1글자\n2. 번호는 무조건 10~11글자'));
                                },
                                isDismissible: false,
                                enableDrag: false);
//                            await Future.delayed(Duration(seconds: 2), (){});
//                            Navigator.pop(context);
                          }
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
                      Text('추가',
                          style: TextStyle(color: Colors.blue, fontSize: 15.0)),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }
}

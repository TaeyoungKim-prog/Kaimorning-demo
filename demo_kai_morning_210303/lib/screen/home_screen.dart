import 'package:demo_kai_morning_210303/screen/sub/create_order.dart';
import 'package:demo_kai_morning_210303/screen/sub/dialog/create_order_day_dialog.dart';
import 'package:demo_kai_morning_210303/screen/sub/dialog/create_order_time_dialog.dart';
import 'package:demo_kai_morning_210303/widgets/body_tab.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:demo_kai_morning_210303/widgets/order_doing_list.dart';
import 'package:demo_kai_morning_210303/widgets/order_done_list.dart';
import 'package:demo_kai_morning_210303/widgets/order_ready_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constant/size.dart';
import 'package:provider/provider.dart';

import '../model/firebase_auth_state.dart';
import '../model/rider_model_state.dart';
import 'show_store_list.dart';
import 'show_user_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  DateTime _selDay;
  String _selTime;

  int selectedTap = 0;

  @override
  void initState() {
    _selDay = DateTime.now();
    _selTime = '종일';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      size = MediaQuery.of(context).size;
      print(size);
    }

    return Consumer<UserModelState>(
      builder: (context, userModelState, _) {
        if (userModelState == null) {
          return MyProgressIndicator();
        } else if (userModelState.userModel == null) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Text('ERROR : 존재하지 않는 유저입니다'),
                  Text('로그인 화면으로 가기'),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      Provider.of<FirebaseAuthState>(context, listen: false)
                          .signOut();
                      Provider.of<UserModelState>(context, listen: false)
                          .clear();
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              key: _drawerKey,
              endDrawer: _drawer(userModelState, context),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    '런치 Lunchy',
                                    style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(
                                  Icons.directions_car,
                                  size: 30.0,
                                  color: Colors.red,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.calendar_today_outlined,
                                    size: 30.0,) ,
                                  onPressed: ()async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DaySelectDialog(selDay: (DateTime dateTime) {
                                          setState(() {
                                            _selDay = dateTime;
                                          });
                                        },
                                          nextFunc: (){},
                                        );
                                      },
                                    );
                                  },
                                ),

                                Expanded(
                                  child: Container(),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    _drawerKey.currentState.openEndDrawer();
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      BodyTab(
                          selectedTab: selectedTap,
                          tab1: () {
                            selectedTap = 0;
                            setState(() {});
                          },
                          tab2: () {
                            selectedTap = 1;
                            setState(() {});
                          },
                          tab3: () {
                            selectedTap = 2;
                            setState(() {});
                          },
                      ),
                      Text("선택날짜: ${_selDay.year}-${_selDay.month}-${_selDay.day}"),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("배달 시간"),
                                        content: SizedBox(
                                          height: 170.0,
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _selTime = '08:30 ~ 09:30';
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(15.0)),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: Colors.grey[300]),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey[500],
                                                              blurRadius: 1.0)
                                                        ]),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 8.0, horizontal: 20.0),
                                                      child: Center(
                                                          child: Text('08:30 ~ 09:30',
                                                              style: TextStyle(
                                                                  color: Colors.black87))),
                                                    )),
                                              ),
                                              SizedBox(height: 10.0),
                                              InkWell(
                                                onTap: () {
                                                  _selTime = '11:00 ~ 12:00';
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(15.0)),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: Colors.grey[300]),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey[500],
                                                              blurRadius: 1.0)
                                                        ]),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 8.0, horizontal: 20.0),
                                                      child: Center(
                                                        child: Text(
                                                          '11:00 ~ 12:00',
                                                          style:
                                                          TextStyle(color: Colors.black87),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(height: 10.0),
                                              InkWell(
                                                onTap: () {
                                                  _selTime = '종일';
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(15.0)),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: Colors.grey[300]),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey[500],
                                                              blurRadius: 1.0)
                                                        ]),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 8.0, horizontal: 20.0),
                                                      child: Center(
                                                        child: Text(
                                                          '종일',
                                                          style:
                                                          TextStyle(color: Colors.black87),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                                      child: Container(
                                          width: 200.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.grey[100]
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(child: Text("픽업")),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: selectedTap,
                          children: [
                            OrderReadyList(selDay: _selDay, selTime: _selTime),
                            OrderDoingList(selDay: _selDay, selTime: _selTime),
                            OrderDoneList(selDay: _selDay, selTime: _selTime)
                          ],
                        ),
                      )
                    ],
                  ),
                  (selectedTap == 0)
                      ? Positioned(
                          bottom: 30.0,
                          right: 30.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 50.0,
                              
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateOrderScreen()));
                            },
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Drawer _drawer(UserModelState userModelState, BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          SizedBox(
              width: size.width * 0.7,
              height: size.height,
              child: Container(
                color: Colors.white,
              )),
          SizedBox(
            width: size.width * 0.7,
            height: size.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("라이더 메뉴",
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Consumer<UserModelState>(
                    builder: (context, userModelState, _) {
                      if (userModelState == null) {
                        return MyProgressIndicator();
                      } else if (userModelState.userModel == null) {
                        return MyProgressIndicator();
                      } else {
                        return Column(
                          children: [
                            Text(userModelState.userModel.userEmail),
                            Text(userModelState.userModel.userName),
                            Text(userModelState.userModel.userNickName),
                            Text(userModelState.userModel.userPhone),
                          ],
                        );
                      }
                    },
                  ),
//                  InkWell(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => RegisterUserPage()));
//                    },
//                    child: Row(
//                      children: [
//                        Icon(
//                          Icons.invert_colors_on,
//                          size: 40.0,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(10.0),
//                          child: Text(
//                            "유저 등록",
//                            style: TextStyle(fontSize: 30),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowUserList()));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_emoticon,
                            size: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "유저 보기",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowStoreList()));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            size: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "가게 보기",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                    child: InkWell(
                      onTap: () {
                        Provider.of<FirebaseAuthState>(context, listen: false)
                            .signOut();
                        Provider.of<UserModelState>(context, listen: false)
                            .clear();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            size: 40.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "로그아웃",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

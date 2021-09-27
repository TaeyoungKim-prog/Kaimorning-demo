import 'package:demo_kai_morning_210303/constant/firestore_keys.dart';
import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/model/rider_model.dart';
import 'package:demo_kai_morning_210303/model/rider_model_state.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:demo_kai_morning_210303/screen/sub/send_photo.dart';
import 'package:demo_kai_morning_210303/widgets/rounded_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_progress_indicator.dart';

class OrderItem extends StatefulWidget {
  final OrderModel orderModel;


  OrderItem({this.orderModel});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
//  orderKey
//  store
//  menu
//  time
//  madeTime
//  goal
//  orderer
//  process

  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {

    RiderModel now_login_user = Provider.of<UserModelState>(context, listen: false).userModel;
    //(now_login_user.userName == widget.orderModel.store || now_login_user.userName == "김태영")? :
    return StreamProvider<UserModel>.value(
      value: userNetwork.getUserModelStream(widget.orderModel.ordererKey),
      child: Consumer<UserModel>(builder: (context, user, _) {
          if (user == null) {
            return MyProgressIndicator();
          } else if (now_login_user.userName == widget.orderModel.store || now_login_user.userName == "김태영") {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey)]),
                child: (widget.orderModel.process == KEY_READY)
                    ? Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 5.0,
                            child: Text('${widget.orderModel.time}',
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Column(
                            children: [
                              Wrap(
                                children: [
                                  Center(child: SizedBox(height: 30.0)),
                                  Center(
                                      child: Text(
                                    '${widget.orderModel.store}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  )),
                                  Center(
                                      child: Text('${widget.orderModel.menu}',
                                          style: TextStyle(fontSize: 15.0))),
                                  Center(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      onPressed: () {
                                        setState(() {
                                          _isOpened = !_isOpened;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              (_isOpened)
                                  ? Column(
                                      children: [
                                        Text(
                                            '날짜 : ${widget.orderModel.orderDay.toString()}'),
                                        Text('${user.userNickname}'),
                                        Text('${user.userPhone}'),
                                        Text('${user.userDest}'),
                                        Text(
                                          '주문시간 : ${widget.orderModel.madeTime}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                            '주문시간 : ${widget.orderModel.ordererKey}'),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('현재 상태'),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.2,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (widget.orderModel.process !=
                                          KEY_READY) {
                                        bool flag = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('상태 변경'),
                                                content: Text(
                                                    '${widget.orderModel.store}\n${widget.orderModel.menu}\n${widget.orderModel.time}\n}\n\n정말 대기 상태로 돌리시겠습니까?'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('변경'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ],
                                              );
                                            });

                                        if (flag != null && flag)
                                          await orderNetwork.changeOrderProcess(
                                              orderKey:
                                                  widget.orderModel.orderKey,
                                              process: KEY_READY);
                                      }
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '대기중',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_READY)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (widget.orderModel.process !=
                                          KEY_DOING) {
                                        bool flag = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('상태 변경'),
                                                content: Text(
                                                    '${widget.orderModel.store}\n${widget.orderModel.menu}\n${widget.orderModel.time}\n}\n\n진행중 상태로 변경하시겠습니까? \n (상품 수령 하신거죠?) \n (아니면 배송 오류?!)'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('변경'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ],
                                              );
                                            });

                                        if (flag != null && flag)
                                          await orderNetwork.changeOrderProcess(
                                              orderKey:
                                                  widget.orderModel.orderKey,
                                              process: KEY_DOING);
                                      }
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '진행중',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_DOING)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SendPhoto(
                                                    orderModel:
                                                        widget.orderModel,
                                                    ordererName:
                                                        user.userNickname,
                                                    ordererPhone:
                                                        user.userPhone,
                                                  )));
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '완료',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_DONE)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 5.0,
                            child: Text('${widget.orderModel.time}',
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 100.0,
                                  ),
                                  Spacer(flex: 1),
                                  Text(
                                    '${widget.orderModel.dest}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Spacer(flex: 1),
                                  Text('${widget.orderModel.menu}',
                                      style: TextStyle(fontSize: 15.0)),
                                  Spacer(flex: 1),
                                  Text('${user.userNickname}',
                                      style: TextStyle(fontSize: 15.0)),
                                  Spacer(flex: 1),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      setState(() {
                                        _isOpened = !_isOpened;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              (_isOpened)
                                  ? Column(
                                      children: [
                                        Text(
                                            '날짜 : ${widget.orderModel.orderDay.toString()}'),
                                        Text('${user.userNickname}'),
                                        Text('${user.userPhone}'),
                                        Text('${user.userDest}'),
                                        Text(
                                          '주문시간 : ${widget.orderModel.madeTime}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.0),
                                        ),
                                        Text(
                                            '주문시간 : ${widget.orderModel.ordererKey}'),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('현재 상태'),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.2,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (widget.orderModel.process !=
                                          KEY_READY) {
                                        bool flag = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('상태 변경'),
                                                content: Text(
                                                    '${widget.orderModel.store}\n${widget.orderModel.menu}\n${widget.orderModel.time}\n}\n\n정말 대기 상태로 돌리시겠습니까?'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('변경'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ],
                                              );
                                            });

                                        if (flag != null && flag)
                                          await orderNetwork.changeOrderProcess(
                                              orderKey:
                                                  widget.orderModel.orderKey,
                                              process: KEY_READY);
                                      }
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '대기중',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_READY)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (widget.orderModel.process !=
                                          KEY_DOING) {
                                        bool flag = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('상태 변경'),
                                                content: Text(
                                                    '${widget.orderModel.store}\n${widget.orderModel.menu}\n${widget.orderModel.time}\n}\n\n진행중 상태로 변경하시겠습니까? \n (상품 수령 하신거죠?) \n (아니면 배송 오류?!)'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('변경'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ],
                                              );
                                            });

                                        if (flag != null && flag)
                                          await orderNetwork.changeOrderProcess(
                                              orderKey:
                                                  widget.orderModel.orderKey,
                                              process: KEY_DOING);
                                      }
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '진행중',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_DOING)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SendPhoto(
                                                    orderModel:
                                                        widget.orderModel,
                                                    ordererName:
                                                        user.userNickname,
                                                    ordererPhone:
                                                        user.userPhone,
                                                  )));
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      child: Text(
                                        '완료',
                                        style: TextStyle(
                                            color: (widget.orderModel.process ==
                                                    KEY_DONE)
                                                ? Colors.red
                                                : Colors.grey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            );
          }
          else{
            return Container();
          }
        }),
    );
  }
}

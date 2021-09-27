import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/useful/generate_key.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dialog/create_order_day_dialog.dart';
import 'dialog/create_order_menu_dialog.dart';
import 'dialog/create_order_store_dialog.dart';
import 'dialog/create_order_time_dialog.dart';
import 'dialog/create_order_user_dialog.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  DateTime _daySelect = DateTime.now();
  String _timeSelect = '';
  String _storeSelect = '';
  String _storeSelectKey;
  String _menuSelect = '';
  String _ordererSelect = '';
  String _ordererSelectKey;
  String _destSelect = '';
  int _prioritySelect;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController foodController = TextEditingController();
  TextEditingController ordererController = TextEditingController();
  TextEditingController destController = TextEditingController();


  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    storeController.dispose();
    foodController.dispose();
    ordererController.dispose();
    destController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 50.0,
                  ),
                  Text(
                    '신규 주문 등록',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('날짜'),
              SizedBox(
                height: 5.0,
              ),
              InkWell(
                  onTap: dialogDay,
                  child: _showContainer(
                      '${DateFormat('yyyy-MM-dd').format(_daySelect)}')),
              SizedBox(
                height: 10.0,
              ),
              Text('시간'),
              SizedBox(
                height: 5.0,
              ),
              InkWell(
                onTap: dialogTime,
                child: _showContainer(_timeSelect),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('가게'),
              SizedBox(
                height: 5.0,
              ),
              InkWell(onTap: dialogStore, child: _showContainer(_storeSelect)),
              SizedBox(
                height: 10.0,
              ),
              Text('메뉴'),
              SizedBox(
                height: 5.0,
              ),
              InkWell(onTap: dialogMenu, child: _showContainer(_menuSelect)),
              SizedBox(
                height: 10.0,
              ),
              Text('주문자 선택'),
              SizedBox(
                height: 5.0,
              ),
           InkWell(onTap: dialogUser, child: _showContainer(_ordererSelect)),
              SizedBox(
                height: 10.0,
              ),
              Text('수령지 선택'),
              SizedBox(
                height: 5.0,
              ),
              InkWell(onTap: dialogDest, child: _showContainer(_destSelect)),
              SizedBox(
                height: 20.0,
              ),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void dialogDay() async {
    await showDialog(
      context: context,
      builder: (context) {
        return DaySelectDialog(selDay: (DateTime dateTime) {
          setState(() {
            _daySelect = dateTime;
          });
        },
        nextFunc:dialogTime ,
        );
      },
    );
  }

  void dialogTime() async {
    await showDialog(
      context: context,
      builder: (context) {
        return TimeSelectDialog(
          selTime: (String selectedTime) {
            setState(() {
              _timeSelect = selectedTime;
            });
          },
          nextFunc: dialogStore,
        );
      },
    );
  }

  void dialogStore() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StoreSelectDialog(
            selStoreAndPriority: (String selStore, int priority, String storeKey) {
              setState(() {
                _storeSelect = selStore;
                _prioritySelect = priority;
                _storeSelectKey = storeKey;
              });
            },
            nextFunc: dialogMenu);
      },
    );
  }

  void dialogMenu() async {
    await showDialog(
      context: context,
      builder: (context) {
        return MenuSelectDialog(
          storeKey: _storeSelectKey,
            selMenu: (String selectedMenu) {
              setState(() {
                _menuSelect = selectedMenu;
              });
            },
            nextFunc: dialogUser);
      },
    );
  }

  void dialogUser() async {
    await showDialog(
      context: context,
      builder: (context) {
        return UserSelectDialog(
            selUser: (String selectedUserKey, String selectedUser,
                {String defaultDest = ''}) {
              setState(() {
                _ordererSelectKey = selectedUserKey;
                _ordererSelect = selectedUser;
                _destSelect = defaultDest;
              });
            },
            nextFunc: dialogDest);
      },
    );
  }

  void dialogDest() async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _destController = TextEditingController();
        _destController.text = _destSelect;

        return AlertDialog(
            title: Text('수령지 변경'),
            content: TextField(
              controller: _destController,
            ),
            actions: [
              FlatButton(
                child: Text(
                  '선택',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _destSelect = _destController.text;
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              FlatButton(
                child: Text('취소', style: TextStyle(color: Colors.black87)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  Container _showContainer(String content) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1.0, color: Colors.grey[300]),
        color: Colors.grey[100],
      ),
      child: Center(
          child: Text(
        content,
        style: TextStyle(color: Colors.black87),
      )),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () async {
        if(_daySelect != '' && _timeSelect != '' && _storeSelect != '' && _menuSelect != '' && _destSelect != '' && _ordererSelect != ''){
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return MyProgressIndicator();
              },
              isDismissible: false,
              enableDrag: false);

          await orderNetwork.createNewOrder(
              orderKey: generateOrderKey(store: _storeSelect),
              store: _storeSelect,
              menu: _menuSelect,
              time: _timeSelect,
              dest: _destSelect,
              ordererKey: _ordererSelectKey,
              orderDay: _daySelect,
              priority: _prioritySelect);

          Navigator.pop(context);

          Navigator.pop(context);
        }
        else{
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Center(child: Text('적절하지 않은 order 양식입니다.'));
              },
              isDismissible: false,
              enableDrag: false);
          await Future.delayed(Duration(seconds: 2), (){});
          Navigator.pop(context);
        }


      },
      child: Text(
        '신규 주문 추가',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}

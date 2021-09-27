import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/model/user_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUserDialog extends StatefulWidget {
  final UserModel userModel;

  ShowUserDialog({this.userModel});

  @override
  _ShowUserDialogState createState() => _ShowUserDialogState();
}

class _ShowUserDialogState extends State<ShowUserDialog> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _destController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = widget.userModel.userPhone;
    _destController.text = widget.userModel.userDest;
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.userModel.userNickname}'),
      content: SizedBox(
          height: size.height * 0.5,
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
                  '수령지',
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
                      controller: _destController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '수령지'),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
      actions: [
        FlatButton(
          onPressed: () async {
            await userNetwork.updateUser(userKey: widget.userModel.userKey, userPhone: _phoneController.text, userDest: _destController.text);
            Navigator.pop(context);
          },
          child: Text(
            '업데이트',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('취소', style: TextStyle(color: Colors.black87),),
        ),
      ],
    );
  }
}

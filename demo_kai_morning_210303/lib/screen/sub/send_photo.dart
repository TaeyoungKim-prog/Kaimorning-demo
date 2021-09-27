import 'dart:io';

import 'package:camera/camera.dart';
import 'package:demo_kai_morning_210303/constant/firestore_keys.dart';
import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/camera_state.dart';
import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SendPhoto extends StatefulWidget {

  final OrderModel orderModel;
  final String ordererName;
  final String ordererPhone;

  SendPhoto({this.orderModel, this.ordererPhone, this.ordererName});

  @override
  _SendPhotoState createState() {
    return _SendPhotoState();
  }
}

class _SendPhotoState extends State<SendPhoto> {

  TextEditingController _messageController = TextEditingController();


  @override
  void initState() {
    _messageController.text = '날짜 : ${widget.orderModel.orderDay.month} / ${widget.orderModel.orderDay.day}\n시간 : ${widget.orderModel.time}\n메뉴 : ${widget.orderModel.menu}(${widget.orderModel.store})\n장소 : ${widget.orderModel.dest}\n\n안녕하십니까 카이모닝입니다.\n${widget.ordererName} 님께서 주문하신 메뉴가 배달되었습니다.\n식사 맛있게 하십시오. ';
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 20.0,),
                Text('미리보기 (수정가능)', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Container(
                  width: size.width*0.8,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                    color: Colors.grey
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 10,
                      decoration: textInputDecor('메세지를 쓰세요.'),
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                FlatButton(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.grey
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('현재 카메라 작동 x \n ${widget.ordererName} 님께 문자보내기 \n 번호 ${widget.ordererPhone}'),
                      )),
                  onPressed: () async {
                    await _sendSMS(_messageController.text, ['${widget.ordererPhone}']);
                    await orderNetwork.changeOrderProcess(orderKey: widget.orderModel.orderKey, process: KEY_DONE);
                    Navigator.pop(context);
                  },
                ),
                Text('이거 버튼임!', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.grey),),
              ],
            ),
          ),
        )
      ),
    );
  }

  Future<void> _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
  }

  InputDecoration textInputDecor(String hint) {
    return InputDecoration(
        hintText: hint,
        enabledBorder: activeInputBorder(),
        focusedBorder: activeInputBorder(),
        errorBorder: errorInputBorder(),
        focusedErrorBorder: errorInputBorder(),
        filled: true,
        fillColor: Colors.grey[100]);
  }

  OutlineInputBorder errorInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
        borderRadius: BorderRadius.circular(12.0));
  }

  OutlineInputBorder activeInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[500],
      ),
      borderRadius: BorderRadius.circular(12.0),
    );
  }

}

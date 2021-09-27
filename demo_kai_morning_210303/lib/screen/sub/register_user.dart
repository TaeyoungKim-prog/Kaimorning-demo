import 'package:demo_kai_morning_210303/network/user_network_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/size.dart';
import '../../model/firebase_auth_state.dart';

class RegisterUserPage extends StatefulWidget {

  final FirebaseAuthState firebaseAuthState;

  RegisterUserPage({this.firebaseAuthState});

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  // userKey: userKey, userNickname: userNickName, userDest: userDest, userPhone: userPhone
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _destController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


  // @override
  // void initState() {
  //   _emailController.text = 'rider@kaist.ac.kr';
  //   _pwController.text = '000000';
  //   _cpwController.text = '000000';
  //   super.initState();
  // }

  @override
  void dispose() {
    _nicknameController.dispose();
    _destController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, size: 50.0,),
                    Text('라이더 아이디 등록', style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),

                SizedBox(
                  height: 10.0,
                ),
                Text('학번'),
                SizedBox(
                  height: 10.0,
                ),
                Text('이름'),
                TextFormField(
                  controller: _nicknameController,
                  decoration: textInputDecor('이름'),
                  cursorColor: Colors.black54,
                  validator: (text) {
                    if (text.isNotEmpty && text.length > 1) {
                      return null;
                    } else {
                      return '정확한 성함을 입력해주세요';
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _destController,
                  decoration: textInputDecor('목적지'),
                  cursorColor: Colors.black54,
                  validator: (text) {
                    if (text.isNotEmpty && text.length > 1) {
                      return null;
                    } else {
                      return '정확한 성함을 입력해주세요';
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: textInputDecor('폰'),
                  cursorColor: Colors.black54,
                  validator: (text) {
                    if (text.isNotEmpty && text.length > 7) {
                      return null;
                    } else {
                      return '정확한 성함을 입력해주세요';
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () async{
        if(_formKey.currentState.validate()){
          print('Validation success!!');
          await userNetwork.createNewUser(userKey: DateTime.now().toString(), userNickName: _nicknameController.text, userDest: _destController.text, userPhone: _phoneController.text);
          Navigator.pop(context);};

      },
      child: Text(
        '회원가입 신청',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
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
        color: Colors.grey[300],
      ),
      borderRadius: BorderRadius.circular(12.0),
    );
  }
}

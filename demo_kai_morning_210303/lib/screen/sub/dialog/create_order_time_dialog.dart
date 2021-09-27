import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:demo_kai_morning_210303/model/store_model.dart';
import 'package:demo_kai_morning_210303/network/store_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeSelectDialog extends StatefulWidget {

  final Function selTime;
  final Function nextFunc;

  TimeSelectDialog({this.selTime, this.nextFunc});

  @override
  _TimeSelectDialogState createState() => _TimeSelectDialogState();
}

class _TimeSelectDialogState extends State<TimeSelectDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("배달 시간"),
      content: SizedBox(
        height: 110.0,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                widget.selTime('08:30 ~ 09:30');
                Navigator.pop(context);
                widget.nextFunc();
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
                widget.selTime('11:00 ~ 12:00');
                Navigator.pop(context);
                widget.nextFunc();
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
          ],
        ),
      ),
    );
  }
}

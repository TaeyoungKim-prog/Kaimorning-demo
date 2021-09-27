import 'package:demo_kai_morning_210303/constant/size.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DaySelectDialog extends StatefulWidget {
  final Function selDay;
  final Function nextFunc;

  DaySelectDialog({this.selDay, this.nextFunc});

  @override
  _DaySelectDialogState createState() => _DaySelectDialogState();
}

class _DaySelectDialogState extends State<DaySelectDialog> {
  CalendarController _calendarController;
  int _year;
  int _month;
  int _day;

  @override
  initState() {
    _year = DateTime.now().year;
    _month = DateTime.now().month;
    _day = DateTime.now().day;
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = size.width;
    double height = size.height;
    return AlertDialog(
      content: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              _topBar(),
              _calendar(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context, "확인");
            // widget.selDay(DateTime(now.date.year))
            widget.selDay(DateTime(_year, _month, _day));
            widget.nextFunc();
          },
        ),
        FlatButton(
          child: Text('취소', style: TextStyle(color: Colors.black87),),
          onPressed: () {
            Navigator.pop(context, "Cancel");
          },
        ),
      ],
    );
  }

  Widget _calendar() {
    return Expanded(
      child: SfCalendar(
        view: CalendarView.month,
        controller: _calendarController,
        onTap: (now) {
          _year = now.date.year;
          _month = now.date.month;
          _day = now.date.day;

        },
      ),
    );
  }

  Widget _topBar() {
    return SizedBox(
      child: Row(
        children: [
          Spacer(flex: 1),
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _calendarController.backward();
              }),
          Spacer(flex: 10),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _calendarController.forward();
            },
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}

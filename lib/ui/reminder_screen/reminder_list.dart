import 'package:flutter/material.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text("Reminder list \ngoes here",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black))),
    );
  }
}

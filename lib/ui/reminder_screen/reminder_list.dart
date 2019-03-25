import 'package:flutter/material.dart';
import 'package:world_holidays/models/holiday_reminder.dart';

import '../../blocs/holiday_reminder_bloc.dart';

class ReminderList extends StatefulWidget {
  final Function switchTab;

  const ReminderList({
    Key key,
    this.switchTab,
  }) : super(key: key);

  @override
  ReminderListState createState() {
    return new ReminderListState();
  }
}

class ReminderListState extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HolidayReminder>>(
      stream: holidayReminderBloc.holidayReminderListValue,
      builder: (BuildContext context,
          AsyncSnapshot<List<HolidayReminder>> snapshot) {
        if (snapshot.hasData) {
          List<HolidayReminder> holidayReminderList = snapshot.data;

          return holidayReminderList.isEmpty
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Your reminder list is empty",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline
                              .copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        RaisedButton(
                          color: Color(0xff3fa7d6),
                          // padding: EdgeInsets.all(16.0),
                          child: Text(
                            "BACK TO HOLIDAYS",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            widget.switchTab(0);
                          },
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                child: Center(
                    child: Text(
                    "You have ${snapshot.data.length} set of reminders",
                    style: Theme.of(context).textTheme.headline,
                  )),
              );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

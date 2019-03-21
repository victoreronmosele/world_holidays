import 'package:flutter/material.dart';
import 'package:world_holidays/ui/reminder_screen/reminder_list.dart';
import 'ui/world_holidays_screen/month_holiday_details.dart';
import 'ui/world_holidays_screen/world_holidays.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Holidays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorldHolidays(),
      // home: MonthHolidayDetails(),
      // home: ReminderList(),
    );
  }
}

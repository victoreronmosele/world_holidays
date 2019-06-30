import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:world_holidays/blocs/app_bloc.dart';
import 'package:world_holidays/blocs/brightness_bloc.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:world_holidays/blocs/holiday_reminder_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/ui/screens/holiday_reminder_page.dart';
import 'package:world_holidays/ui/screens/home_tab.dart';
import 'package:world_holidays/ui/screens/reminder_tab.dart';
import 'package:world_holidays/ui/screens/settings_page.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentYear = DateTime.now().year.toString();
  NotificationBloc notificationBloc;
  HolidayReminderBloc holidayReminderBloc;
  StatusBarColorBloc statusBarColorBloc;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    Future.delayed(Duration.zero, () {
      notificationBloc = BlocProvider.of<AppBloc>(context).notificationBloc;
      notificationBloc
          .setFlutterLocalNotificationsPlugin(flutterLocalNotificationsPlugin);
    });
  }

  Future onSelectNotification(String payload) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HolidayReminderPage(payload: payload)));
  }

  int _currentIndex = 0;

  switchTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HolidayBloc holidayBloc = BlocProvider.of<AppBloc>(context).holidayBloc;
    holidayReminderBloc = BlocProvider.of<AppBloc>(context).holidayReminderBloc;
    statusBarColorBloc = BlocProvider.of<AppBloc>(context).statusBarColorBloc;

    Widget buildRefreshButton() {
      return IconButton(
        key: ValueKey(5),
        icon: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          holidayBloc.refreshHolidays();
        },
      );
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarColor: statusBarColorBloc.brightnessValue, // status bar color
    ));

    var animatedSwitcher = AnimatedSwitcher(
      duration: Duration(
        milliseconds: 300,
      ),
      child: _currentIndex == 1
          ? buildClearRemindersButton()
          : buildRefreshButton(),
    );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));

              setState(() {});
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Center(
              child: AnimatedSwitcher(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: _currentIndex == 1
                      ? Text("Reminder", key: ValueKey(2))
                      : Text(currentYear, key: ValueKey(3))),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            animatedSwitcher,
          ],
        ),
        body: AnimatedSwitcher(
          duration: Duration(
            milliseconds: 500,
          ),
          child: _currentIndex == 1
              ? ReminderTab(key: ValueKey(0), switchTab: switchTab)
              : HomeTab(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      switchTab(0);
                    },
                    child: SizedBox(
                      height: 60.0,
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 5.0,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: _currentIndex == 0 ? 1.0 : 0.0,
                              child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                                  color:
                                      Theme.of(context).primaryIconTheme.color),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.home,
                            size: 24.0,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      switchTab(1);
                    },
                    child: SizedBox(
                      height: 60.0,
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 5.0,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: _currentIndex == 1 ? 1.0 : 0.0,
                              child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                                  color:
                                      Theme.of(context).primaryIconTheme.color),
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.alarm,
                            size: 24.0,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // color: Colors.blueGrey,
        ),
      ),
    );
  }

  showClearRemindersConfirmation() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Clear all reminders?",
            style:
                Theme.of(context).textTheme.headline.copyWith(fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "NOT NOW",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "CLEAR ALL",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                _cancelAllNotifications();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll().then((onValue) {
      setState(() {
        holidayReminderBloc.deleteAllHolidayReminders();
      });
    });
  }

  Widget buildClearRemindersButton() {
    return StreamBuilder(
        stream: holidayReminderBloc.monthIndexToHolidayReminderListMap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isReminderListEmpty = snapshot.data.isEmpty;

            // This shows the clear reminders button only if the reminder list is not empty
            //The IgnorePointer and Opacity widgets are used to let the clear icon take up space
            //while remaining invisible
            return IgnorePointer(
              ignoring: isReminderListEmpty,
              child: Opacity(
                opacity: isReminderListEmpty == true ? 0 : 1,
                child: IconButton(
                  key: ValueKey(4),
                  icon: Icon(
                    Icons.clear_all,
                  ),
                  onPressed: () {
                    showClearRemindersConfirmation();
                  },
                ),
              ),
            );
          }
          return Container();
        });
  }
}

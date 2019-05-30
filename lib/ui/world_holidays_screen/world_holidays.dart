import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:world_holidays/models/holiday_data.dart';
import 'package:world_holidays/ui/reminder_screen/reminder_list.dart';
import '../../blocs/brightness_bloc.dart';
import '../../resources/custom_country_code_picker/custom_country_code_picker.dart';
import '../../resources/months_color.dart';
import '../settings_screen/settings_screen.dart';
import 'country_title.dart';
import 'month_holiday_details.dart';
import '../../blocs/holiday_reminder_bloc.dart';

class WorldHolidays extends StatefulWidget {
  WorldHolidays({
    Key key,
  }) : super(key: key);

  @override
  _WorldHolidaysState createState() => _WorldHolidaysState();
}

class _WorldHolidaysState extends State<WorldHolidays> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    notificationBloc
        .setFlutterLocalNotificationsPlugin(flutterLocalNotificationsPlugin);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Icon(
            Icons.alarm_on,
            color: Theme.of(context).textTheme.button.color.withOpacity(0.7),
            size: 72.0,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                  child: Text(
                payload,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline,
              )),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                "This is a reminder that today is $payload",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline.color,
                    fontWeight: FontWeight.w300),
              )),
              SizedBox(
                height: 32.0,
              ),
              Container(
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textColor: Colors.white,
                  child: Text(
                    "GOT IT",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      // statusBarColor: Colors.grey[500], // status bar color
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
                  MaterialPageRoute(builder: (context) => SettingsScreen()));

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
                      ? Text("Reminder",
                          // style: Theme.of(context).textTheme.headline,
                          key: ValueKey(2))
                      : Text(currentYear,
                          // style: Theme.of(context).textTheme.title,
                          key: ValueKey(3))
                  // TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
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
              ? ReminderList(key: ValueKey(0), switchTab: switchTab)
              : Container(
                  key: ValueKey(1),
                  // color: Colors.white,
                  child: Column(children: <Widget>[
                    CountryTitle(),
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CountryCodePicker(
                                initialSelection: holidayBloc
                                    .currentSelectedCountryCodeValue.value,
                                onChanged: (countryCode) async {
                                  if (countryCode != null) {
                                    holidayBloc.setCurrentCountryDetails(
                                      countryCode: countryCode.toCountryCode(),
                                      countryName:
                                          countryCode.toCountryString(),
                                    );
                                  }
                                },
                              ),
                              Text(
                                'Select Country',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .display2
                                            .color),
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    MonthCards(
                      countryCode:
                          holidayBloc.currentSelectedCountryCodeValue.value,
                      countryName:
                          holidayBloc.currentSelectedCountryNameValue.value,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                  ]),
                ),
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
                    // onTap: switchTab(1),
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

  IconButton buildClearRemindersButton() {
    return IconButton(
      key: ValueKey(4),
      icon: Icon(
        Icons.clear_all,
      ),
      onPressed: () {
        showClearRemindersConfirmation();
      },
    );
  }

  IconButton buildRefreshButton() {
    return IconButton(
      key: ValueKey(5),
      icon: Icon(
        Icons.refresh,
      ),
      onPressed: () {
        // setState(() {
        holidayBloc.refreshHolidays();
        // });
      },
    );
  }
}

class MonthCards extends StatefulWidget {
  final String countryCode;
  final String countryName;

  const MonthCards({
    this.countryCode,
    this.countryName,
    Key key,
  }) : super(key: key);

  @override
  MonthCardsState createState() {
    return new MonthCardsState();
  }
}

class MonthCardsState extends State<MonthCards> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getMonthCard(
    AsyncSnapshot snapshot,
    Map<String, List<Holiday>> monthToHolidayListMap,
    String month,
  ) {
    int monthIndex = monthToColorMap.keys.toList().indexOf(month);

    if (snapshot.hasData) {
      var listOfHolidayLists = monthToHolidayListMap.values.toList();
      List<Holiday> holidayList = listOfHolidayLists[monthIndex];

      if (holidayList.isEmpty) {
        return Align(
          alignment: Alignment(0.0, 0.0),
          child: Text(
            "No holidays \nfor this month",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.isEmpty ? "N/A" : holidayList.elementAt(0).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.length < 2 ? "" : holidayList.elementAt(1).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.length < 3 ? "" : holidayList.elementAt(2).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('${holidayList.length >= 3 ? "..." : ""}',
                    style: TextStyle(color: Colors.white70))),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: holidayList.length.toString(),
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${holidayList.length == 1 ? ' holiday' : " holidays"}',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal))
                      ])),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      return Align(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          "Not available",
          style: TextStyle(color: Colors.white, fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      );
    }
// By default, show a loading spinner
    return Align(
      alignment: Alignment(0.0, 0.0),
      child: SpinKitThreeBounce(
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: Container(
        child: StreamBuilder(
            stream: holidayBloc.holidaysValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Map<String, List<Holiday>> monthToHolidayListMap =
                  holidayBloc.getMapOfMonthToHolidayList(snapshot);

              return GridView.count(
                mainAxisSpacing: 2,
                controller: controller,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                crossAxisCount: 1,
                padding: EdgeInsets.only(left: kFloatingActionButtonMargin),
                childAspectRatio: 1.5,
                children: monthToColorMap.keys.map((String month) {
                  int monthIndex = monthToColorMap.keys.toList().indexOf(month);

                  return Hero(
                    tag: 'hero-tag' + month,
                    // flightShuttleBuilder: (
                    //   BuildContext flightContext,
                    //   Animation<double> animation,
                    //   HeroFlightDirection flightDirection,
                    //   BuildContext fromHeroContext,
                    //   BuildContext toHeroContext,
                    // ) {
                    //   return Flex(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: <Widget>[
                    //     Expanded(child: fromHeroContext.widget),
                    //   ], direction: Axis.horizontal,
                    // );
                    // },
                    child: Material(
                      color: Colors.transparent,
                      child: Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(right: 10),
                        child: Material(
                          color: monthToColorMap[month],
                          child: InkWell(
                            onTap: () async {
                              if (snapshot.hasData) {
                                List<List<Holiday>> listOfHolidayLists =
                                    monthToHolidayListMap.values.toList();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MonthHolidayDetails(
                                              monthIndex: monthIndex,
                                              // month: month,
                                              listOfHolidayList:
                                                  listOfHolidayLists,
                                              countryName: widget.countryName,
                                            )));
                              }
                            },
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                        alignment: Alignment(-1.0, 0.5),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(month,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ))),
                                Divider(
                                  indent: 16,
                                  color: Colors.white54,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                      child: Align(
                                          alignment: Alignment(0.0, -0.4),
                                          child: getMonthCard(snapshot,
                                              monthToHolidayListMap, month))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

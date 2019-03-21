import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:world_holidays/models/holiday_data.dart';
import 'package:world_holidays/ui/reminder_screen/reminder_list.dart';
import '../../resources/months_color.dart';
import 'country_title.dart';
import 'month_holiday_details.dart';

class WorldHolidays extends StatefulWidget {
  WorldHolidays({
    Key key,
  }) : super(key: key);

  @override
  _WorldHolidaysState createState() => _WorldHolidaysState();
}

class _WorldHolidaysState extends State<WorldHolidays> {
  String _selectedCountry;
  String _countryCode;
  String _flagUri;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//TODO Rearrange code
//TODO Implement notifications
//TODO Track with shared preferences which holiday has been added to reminder list
//TODO Implememnt dark mode
//TODO Style app
  @override
  void initState() {
    super.initState();
    print("init");
    _selectedCountry = "Nigeria";
    _flagUri = 'ng.png';

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
    print(payload);
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Icon(
            Icons.alarm_on,
            color: Colors.black54,
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
                style: Theme.of(context).textTheme.title,
              )),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                "This is a reminder that today is $payload",
                textAlign: TextAlign.center,
              )),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textColor: Colors.white,
                  color: monthToColorMap.values.toList()[1],
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Center(
              
              child: 
              AnimatedSwitcher(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: _currentIndex == 1
                      ? Text("Reminder",
                          style: Theme.of(context).textTheme.title,
                          key: ValueKey(2))
                      : Text("2019",
                          style: Theme.of(context).textTheme.title,
                          key: ValueKey(3))
                  // TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            AnimatedSwitcher(
              duration: Duration(
                milliseconds: 300,
              ),
              child: _currentIndex == 1
                  ? IconButton(
                      key: ValueKey(4),
                      icon: Icon(
                        Icons.clear_all,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        //This empty setState is used to refire the FutureBuilder
                        setState(() {});
                      },
                    )
                  : IconButton(
                      key: ValueKey(5),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        //This empty setState is used to refire the FutureBuilder
                        setState(() {});
                      },
                    ),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: Duration(
            milliseconds: 500,
          ),
          child: _currentIndex == 1
              ? ReminderList(key: ValueKey(0))
              : Container(
                  key: ValueKey(1),
                  // color: Colors.white,
                  child: Column(children: <Widget>[
                    CountryTitle(selectedCountry: _selectedCountry),
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: (countryCode) async {
                                  setState(() {
                                    _selectedCountry =
                                        countryCode.toCountryString();
                                    _countryCode = countryCode.toCountryCode();

                                    _flagUri = countryCode.toFlagUri();
                                  });
                                },
                              ),
                              Text(
                                'Select Country',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 12),
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    MonthCards(
                      _countryCode,
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
                  color: Colors.amber,
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      switchTab(0);
                    },
                    child: SizedBox(
                      height: 60.0,
                      child: Icon(Icons.home, size: 24.0),
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
                      child:
                          // Column(
                          //   mainAxisSize: MainAxisSize.min,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          Icon(Icons.alarm, size: 24.0),
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
}

class MonthCards extends StatefulWidget {
  final String countryCode;

  const MonthCards(
    this.countryCode, {
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
      child: JumpingDotsProgressIndicator(
        color: Colors.white70,
        fontSize: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: Container(
        child: FutureBuilder(
            future: holidayBloc.getHolidays(widget.countryCode),
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
                    child: Material(
                      color: Colors.transparent,
                      child: Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(right: 10),
                        child: Material(
                          color: monthToColorMap[month],
                          child: InkWell(
                            onTap: () async {
                              print(monthIndex.toString());
                              print(month);
                              // if (snapshot.hasData) {
                              List<List<Holiday>> listOfHolidayLists =
                                  monthToHolidayListMap.values.toList();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MonthHolidayDetails(
                                          monthIndex: monthIndex,
                                          // month: month,
                                          listOfHolidayList:
                                              listOfHolidayLists)));
                              // }
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
                                          child: Hero(
                                            tag: "month-text" +
                                                monthIndex.toString(),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(month,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
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

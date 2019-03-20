import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:world_holidays/models/holiday_data.dart';
import '../../resources/months_color.dart';
import 'bottom_navigation_bar.dart';
import 'country_title.dart';
import 'month_holiday_details.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

//TODO Implement notifications
//TODO Move gridview to current month first
//TODO Move grid view to last viewed on navigato pop
//TODO Implememnt dark mode
//TODO Implement reminder screen
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
  }

  Future _showNotificationWithSound() async {
    print("show notification with sound");
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      sound: 'slow_spring_board',
      importance: Importance.Max,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'World Holidays',
    'Today is April Fool\'s day!',
    platformChannelSpecifics,
    payload: 'April Fool\'s Day',
  );
}

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Today is $payload !"),
          content: Text("This is a reminder that today is $payload"),
        );
      },
    );
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
            onPressed:
            //  () {
              //This is one to refire the FutureBuilder
              // setState(() {});
              _showNotificationWithSound,
            // },
          ),
          title: Center(
            child: Text("2019", style: Theme.of(context).textTheme.title
                // TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black38,
              ),
              onPressed: () {
                //This is one to refire the FutureBuilder
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
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
                            _selectedCountry = countryCode.toCountryString();
                            _countryCode = countryCode.toCountryCode();

                            _flagUri = countryCode.toFlagUri();
                          });
                        },
                      ),
                      Text(
                        'Select Country',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
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
        bottomNavigationBar: BottomNavigationBarWidget(),
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
                              if (snapshot.hasData) {
                                List<List<Holiday>> listOfHolidayLists =
                                    monthToHolidayListMap.values.toList();
                                List<Holiday> holidayList =
                                    listOfHolidayLists[monthIndex];
                                print(listOfHolidayLists == null);
                                final currentIndex = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MonthHolidayDetails(
                                                monthIndex: monthIndex,
                                                // month: month, 
                                                listOfHolidayList: listOfHolidayLists)));
                                print(
                                    "returned data " + currentIndex.toString());
                                // controller.jumpTo(currentIndex);
                                // controller.animateTo(6.0,
                                //     curve: null, duration: null);
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

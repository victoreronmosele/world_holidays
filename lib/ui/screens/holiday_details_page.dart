import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:world_holidays/blocs/app_bloc.dart';
import 'package:world_holidays/blocs/holiday_reminder_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_data.dart';
import 'package:world_holidays/models/holiday_reminder.dart';
import 'package:world_holidays/resources/custom_expansion_panel.dart';
import 'package:world_holidays/ui/screens/settings_page.dart';

import '../../resources/months_color.dart';

class HolidayDetailsPage extends StatefulWidget {
  final int monthIndex;
  final List<List<Holiday>> listOfHolidayList;
  final String countryName;

  HolidayDetailsPage(
      {Key key,
      @required this.countryName,
      @required this.monthIndex,
      @required this.listOfHolidayList})
      : super(key: key);

  @override
  HolidayDetailsPageState createState() {
    return new HolidayDetailsPageState();
  }
}

class HolidayDetailsPageState extends State<HolidayDetailsPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int initialMonthIndex;
  int currentMonthIndex;
  double screenWidth;
  List<List<Holiday>> listOfHolidayLists;
  List<Holiday> currentMonthHolidayList;
  Animation<double> dividerIndentAnimation;
  AnimationController animationController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationBloc notificationBloc;
  HolidayReminderBloc holidayReminderBloc;

  @override
  void initState() {
    super.initState();
    initialMonthIndex = widget.monthIndex;
    currentMonthIndex = initialMonthIndex;
    listOfHolidayLists = widget.listOfHolidayList;
    currentMonthHolidayList = listOfHolidayLists[currentMonthIndex];

    _pageController = PageController(initialPage: initialMonthIndex);

    animationController =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);

    dividerIndentAnimation = Tween<double>(begin: 5000.0, end: 0.0)
        //Chose 5000.0 as arbitrary begin value
        .animate(animationController)
          ..addListener(() {
            setState(() {
              //This animates the divider indent by update its state
            });
          });

    animationController.forward();
    Future.delayed(Duration.zero, () {
      notificationBloc = BlocProvider.of<AppBloc>(context).notificationBloc;

      flutterLocalNotificationsPlugin =
          notificationBloc.getFlutterLocalNotificationsPlugin();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future _scheduleNotification(DateTime scheduledNotificationDateTime,
      String holidayName, int notificationsChannelId) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        sound: 'slow_spring_board',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return await flutterLocalNotificationsPlugin.schedule(
      notificationsChannelId,
      'Reminder: $holidayName',
      'Today is $holidayName.',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: holidayName,
    );
  }

  @override
  Widget build(BuildContext context) {
    holidayReminderBloc = BlocProvider.of<AppBloc>(context).holidayReminderBloc;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()))),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.pop(context, currentMonthIndex);
              },
            ),
          ],
        ),
        body: PageView.builder(
          onPageChanged: (pageId) {
            setState(() {
              currentMonthIndex = pageId;
              currentMonthHolidayList = listOfHolidayLists[currentMonthIndex];
            });
          },
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: monthToColorMap.length,
          itemBuilder: (context, position) {
            String month = monthToColorMap.keys.toList()[position];
            return Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    // color: Colors.black,
                    ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: ListTile(
                    leading: Text(""),
                    title: Material(
                      color: Colors.transparent,
                      child: Text(
                        month,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "${currentMonthHolidayList.length == 0 ? "No" : currentMonthHolidayList.length} ${currentMonthHolidayList.length == 1 ? "holiday" : "holidays"}",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Divider(
                          indent: dividerIndentAnimation.value,
                          height: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                        Spacer(
                          flex: 2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 11,
                child: currentMonthHolidayList.isEmpty
                    ? Center(
                        child: Text(
                          "No holidays this month",
                          style: Theme.of(context)
                              .textTheme
                              .headline
                              .copyWith(fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          child: SafeArea(
                            child: Container(
                              child: CustomExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    currentMonthHolidayList[index].isExpanded =
                                        !currentMonthHolidayList[index]
                                            .isExpanded;
                                  });
                                },
                                children: currentMonthHolidayList
                                    .map((Holiday holiday) {
                                  return CustomExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        // dense: true,
                                        title: Text(
                                          holiday.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),

                                        subtitle: Text(
                                          // DateFormat
                                          DateFormat.EEEE()
                                              .format(DateTime.parse(
                                                  holiday.date.iso))
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              // .subhead
                                              .subtitle
                                              .copyWith(
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                        leading: Text(
                                          holiday.date.datetime.day.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(
                                                  fontWeight: FontWeight.w300),
                                        ),
                                        trailing:
                                            //This shows the reminder icon only for future dates
                                            DateTime.now().isAfter(
                                                    DateTime.parse(
                                                        holiday.date.iso))
                                                ? null
                                                : buildReminderButton(holiday,
                                                    currentMonthIndex, month),
                                      );
                                    },
                                    body: Container(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ListTile(
                                          // dense: true,
                                          leading: Text(""),
                                          title: Text(
                                            holiday.description ??
                                                "No description available",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ),
                                    isExpanded: holiday.isExpanded,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ]);
          },
        ),
        bottomNavigationBar: Container(
          height: kBottomNavigationBarHeight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthToColorMap.keys.map((String month) {
                int monthIndex = monthToColorMap.keys.toList().indexOf(month);
                return Hero(
                  tag: 'hero-tag' + month,
                  flightShuttleBuilder: (
                    BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext,
                  ) {
                    return Flex(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(child: fromHeroContext.widget),
                      ],
                      direction: Axis.horizontal,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: MediaQuery.of(context).size.width / 32,
                        height: currentMonthIndex == monthIndex
                            ? kBottomNavigationBarHeight / 1.2
                            : kBottomNavigationBarHeight / 2.0,
                        color: monthToColorMap.values.toList()[monthIndex],
                        // child: Text("kk"),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ), // ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  Widget buildReminderButton(
      Holiday holiday, int currentMonthIndex, String month) {
    String holidayId = holiday.name + widget.countryName;

    return FutureBuilder<bool>(
      future: holidayReminderBloc.isHolidayInReminderList(holidayId),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool isHolidayInReminderList = snapshot.data;
          //Parsed to Int32 and back to int because "int" for Dart is a 64-bit integer
          // and "int" for Java is a 32-bit integer so Java reads Dart's int as a Long which is not compatible
          //So it is converted to Int32 to remain only the lower 32 bits of the number, and then to int again
          //Check this github issue for some more light https://github.com/MaikuB/flutter_local_notifications/issues/115#issuecomment-433553398
          int notificationsChannelId = Int32((holidayId.hashCode)).toInt();

          return AnimatedSwitcher(
            duration: Duration(
              milliseconds: 500,
            ),
            child: isHolidayInReminderList
                ? IconButton(
                    key: ValueKey(0),
                    icon: Icon(
                      Icons.alarm_on,
                      color: monthToColorMap.values.toList()[currentMonthIndex],
                    ),
                    onPressed: () async {
                      setState(
                        () {
                          holidayReminderBloc.deleteHolidayReminder(
                              holidayId, month);
                        },
                      );

                      await flutterLocalNotificationsPlugin
                          .cancel(notificationsChannelId);
                    },
                  )
                : IconButton(
                    key: ValueKey(1),
                    icon: Icon(
                      Icons.alarm_off,
                    ),
                    onPressed: () {
                      HolidayReminder holidayReminder = HolidayReminder(
                        id: holidayId,
                        name: holiday.name,
                        description:
                            holiday.description ?? "No description available",
                        country: widget.countryName,
                        monthIndex: currentMonthIndex,
                        monthString:
                            monthToColorMap.keys.toList()[currentMonthIndex],
                        date: holiday.date.datetime.day.toString(),
                        dayOfTheWeek: DateFormat.EEEE()
                            .format(DateTime.parse(holiday.date.iso))
                            .toString(),
                        notificationsChannelId: notificationsChannelId,
                      );

                      setState(
                        () {
                          holidayReminderBloc.addNewHoliday(holidayReminder);
                        },
                      );

                      _scheduleNotification(DateTime.parse(holiday.date.iso),
                          holiday.name, notificationsChannelId);
                    },
                  ),
          );
        } else {
          return IconButton(
              icon: Icon(
                Icons.alarm_off,
              ),
              onPressed: null);
        }
      },
    );
  }
}

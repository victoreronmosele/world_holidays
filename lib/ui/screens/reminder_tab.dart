import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_holidays/blocs/app_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_reminder.dart';
import 'package:world_holidays/resources/custom_expansion_panel.dart';
import 'package:world_holidays/resources/months_color.dart';

import '../../blocs/holiday_reminder_bloc.dart';

class ReminderTab extends StatefulWidget {
  final Function switchTab;

  const ReminderTab({
    Key key,
    this.switchTab,
  }) : super(key: key);

  @override
  ReminderTabState createState() {
    return new ReminderTabState();
  }
}

class ReminderTabState extends State<ReminderTab>
    with SingleTickerProviderStateMixin {
  Animation<double> dividerIndentAnimation;
  AnimationController animationController;
  //App Bar height is toolbar height since there is no bottom widget set in the app bar
  double appBarHeight = kToolbarHeight;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationBloc notificationBloc;
  HolidayReminderBloc holidayReminderBloc;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    holidayReminderBloc = BlocProvider.of<AppBloc>(context).holidayReminderBloc;
    double screenHeightWithoutAppBarAndBottomNavBar =
        (MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            appBarHeight);
    double reminderMonthTitleMarginHeight =
        screenHeightWithoutAppBarAndBottomNavBar / 15;
    double reminderMonthTitleHeight =
        screenHeightWithoutAppBarAndBottomNavBar * 2 / 15;

    return StreamBuilder<Map<String, List<HolidayReminder>>>(
      stream: holidayReminderBloc.monthIndexToHolidayReminderListMap,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<HolidayReminder>>> snapshot) {
        if (snapshot.hasData) {
          Map<String, List<HolidayReminder>>
              monthIndexToHolidayReminderListMap = snapshot.data;

          if (monthIndexToHolidayReminderListMap.isEmpty) {
            return Container(
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
                      child: Text(
                        "Back to Holidays".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        widget.switchTab(0);
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: monthIndexToHolidayReminderListMap.keys
                    .toList()
                    .map((String month) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: reminderMonthTitleMarginHeight,
                      ),
                      Container(
                        height: reminderMonthTitleHeight,
                        child: ListTile(
                          leading: Text(""),
                          title: Text(
                            month,
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).textTheme.headline.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Spacer(),
                              Text(
                                "${monthIndexToHolidayReminderListMap[month].length == 0 ? "No" : monthIndexToHolidayReminderListMap[month].length} ${monthIndexToHolidayReminderListMap[month].length == 1 ? "holiday" : "holidays"}",
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

                          // ),
                        ),
                      ),
                      SizedBox(
                        height: reminderMonthTitleMarginHeight,
                      ),
                      CustomExpansionPanelList(
                        key: PageStorageKey<String>(month),
                        expansionCallback: (int index, bool isExpanded) {
                          monthIndexToHolidayReminderListMap[month][index]
                                  .isExpanded =
                              !monthIndexToHolidayReminderListMap[month][index]
                                  .isExpanded;

                          holidayReminderBloc
                              .monthIndexToHolidayReminderListMapSubject.sink
                              .add(monthIndexToHolidayReminderListMap);
                        },
                        children: monthIndexToHolidayReminderListMap[month]
                            .map((HolidayReminder holidayReminder) {
                          int monthIndex =
                              monthIndexToHolidayReminderListMap[month]
                                  .indexOf(holidayReminder);
                          String holidayId = holidayReminder.id;
                          return CustomExpansionPanel(
                            // key:
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                  title: Text(
                                    holidayReminder.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        holidayReminder.dayOfTheWeek,
                                        style: Theme.of(context)
                                            .textTheme
                                            // .subhead
                                            .subtitle
                                            .copyWith(
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                            color: monthToColorMap[month]
                                                .withOpacity(0.5),
                                          ),
                                        )),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            holidayReminder.country,
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .display3
                                                      .color,
                                                ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                    ],
                                  ),
                                  leading: Text(
                                    holidayReminderBloc
                                        .monthIndexToHolidayReminderListMapSubject
                                        .value[month][monthIndex]
                                        .date,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ),
                                  trailing: IconButton(
                                    color:
                                        monthToColorMap[month].withOpacity(0.7),
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        holidayReminderBloc
                                            .deleteHolidayReminder(
                                                holidayId, month);
                                      });

                                      await flutterLocalNotificationsPlugin
                                          .cancel(holidayReminder
                                              .notificationsChannelId);
                                    },
                                  ));
                            },
                            body: Container(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ListTile(
                                  leading: Text(""),
                                  title: Text(
                                    holidayReminder.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            isExpanded: holidayReminder.isExpanded,
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: reminderMonthTitleMarginHeight,
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        } else {
          return Container(
            margin: EdgeInsets.only(
              bottom: kBottomNavigationBarHeight,
            ),
            child: Center(
              child: SpinKitThreeBounce(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                size: 50.0,
              ),
            ),
          );
        }
      },
    );
  }
}

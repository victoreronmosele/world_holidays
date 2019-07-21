import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:world_holidays/blocs/app_bloc.dart';
import 'package:world_holidays/blocs/holiday_reminder_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_reminder.dart';
import 'package:world_holidays/resources/app_constants.dart';
import 'package:world_holidays/ui/home.dart';

class HolidayReminderPage extends StatelessWidget {
  final String payload;

  HolidayReminderPage({Key key, @required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HolidayReminderBloc holidayReminderBloc =
        BlocProvider.of<AppBloc>(context).holidayReminderBloc;

    Widget svg = new SvgPicture.asset(
      Theme.of(context).brightness == Brightness.dark
          ? darkThemeHolidayReminderIllustration
          : lightThemeHolidayReminderIllustration,
    );

    return SafeArea(
      child: FutureBuilder<HolidayReminder>(
          future: holidayReminderBloc.getHoliday(payload),
          builder: (context, snapshot) {
            String holidayName;
            String holidayDescription;

            if (snapshot.hasData) {
              HolidayReminder currentHolidayReminder = snapshot.data;
              holidayName = currentHolidayReminder.name;
              holidayDescription = currentHolidayReminder.description;
            } else {
              holidayName = '...';
              holidayDescription = '...';
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(holidayName ?? "",
                    style: Theme.of(context).textTheme.headline.copyWith(),
                    textAlign: TextAlign.center),
                elevation: 0.0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(flex: 6, child: svg),
                      Flexible(
                          flex: 4,
                          child: Center(
                            child: Text(
                              holidayDescription,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          )),
                      RaisedButton(
                        color: Colors.transparent,
                        onPressed: () => goToHome(context),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: double.infinity,
                          height: 48.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? darkThemeButtonGradientColors
                                  : lightThemeButtonGradientColors,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: const Text('Go to holidays',
                                style: TextStyle(
                                    // fontSize: 20
                                    )),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          }),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }
}

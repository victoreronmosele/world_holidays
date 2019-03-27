import 'package:flutter/material.dart';
import 'package:world_holidays/ui/reminder_screen/reminder_list.dart';
import 'ui/world_holidays_screen/month_holiday_details.dart';
import 'ui/settings_screen/settings_screen.dart';
import 'ui/world_holidays_screen/world_holidays.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    ThemeData lightThemeData = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.grey,
      primaryColor: Colors.grey[50],
      textTheme: theme.textTheme.copyWith(
        headline: theme.textTheme.headline.copyWith(
          color: Colors.black,
        ),
        display1: theme.textTheme.headline.copyWith(
          color: Colors.black38,
        ),
        //This is just title with another color
        display2: theme.textTheme.title.copyWith(
          color: Colors.black54,
        ),
        caption: theme.textTheme.caption.copyWith(color: Colors.black38),
        button: theme.textTheme.button.copyWith(color: Colors.black),
        subhead: theme.textTheme.subhead.copyWith(color: Colors.black38),
        subtitle: theme.textTheme.subtitle.copyWith(color: Colors.black38),
      ),
      iconTheme: theme.iconTheme.copyWith(color: Colors.indigoAccent),
    );

    ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[850],
      // primarySwatch: Colors.grey[850],
      textTheme: theme.textTheme.copyWith(
        headline: theme.textTheme.headline.copyWith(
          color: Colors.white,
        ),
        display1: theme.textTheme.headline.copyWith(
          color: Colors.white30,
        ),
        //This is just title with another color
        display2: theme.textTheme.title.copyWith(
          color: Colors.white54,
        ),

        caption: theme.textTheme.caption.copyWith(color: Colors.white30),
        button: theme.textTheme.button.copyWith(color: Colors.white),
        subhead: theme.textTheme.subhead.copyWith(color: Colors.white30),
        subtitle: theme.textTheme.subtitle.copyWith(color: Colors.white30),
      ),
      iconTheme: theme.iconTheme.copyWith(color: Colors.white30),
    );

    return 
    DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) =>
          brightness == Brightness.dark ? darkThemeData :
           lightThemeData,
      themedWidgetBuilder: (context, theme) => 
      MaterialApp(
            title: 'World Holidays',
            debugShowCheckedModeBanner: false,
            //TODO Get font

            // checkerboardRasterCacheImages: true,
            // checkerboardOffscreenLayers: true,
            // debugShowMaterialGrid: true,
            // showSemanticsDebugger: true,
            // showPerformanceOverlay: true,

            // theme: darkThemeData,
            theme: theme,
            home: WorldHolidays(),
            // home: MonthHolidayDetails(),
            // home: ReminderList(),
            // SettingsScreen(),
          ),
    );
  }
}

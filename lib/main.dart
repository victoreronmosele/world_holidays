import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:world_holidays/resources/months_color.dart';
import 'blocs/brightness_bloc.dart';
import 'ui/world_holidays_screen/world_holidays.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
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
        display3: theme.textTheme.title.copyWith(
          color: Colors.black87,
        ),
        caption: theme.textTheme.caption.copyWith(color: Colors.black38),
        button: theme.textTheme.button.copyWith(color: Colors.black),
        subhead: theme.textTheme.subhead.copyWith(color: Colors.black38),
        subtitle: theme.textTheme.subtitle.copyWith(color: Colors.black38),
      ),
      iconTheme: theme.iconTheme.copyWith(color: Colors.black38),
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

        display3: theme.textTheme.title.copyWith(
          color: Colors.white70,
        ),
        caption: theme.textTheme.caption.copyWith(color: Colors.white30),
        button: theme.textTheme.button.copyWith(color: Colors.white),
        subhead: theme.textTheme.subhead.copyWith(color: Colors.white30),
        subtitle: theme.textTheme.subtitle.copyWith(color: Colors.white30),
      ),
      iconTheme: theme.iconTheme.copyWith(color: Colors.white30),
    );

    return DynamicTheme(data: (brightness) {
      ThemeData currentThemeData;

      if (brightness == Brightness.dark) {
        statusBarColorBloc.setBrightness(darkThemeData.primaryColor);

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor:
                statusBarColorBloc.brightnessValue, // status bar color
          ),
        );
        return darkThemeData;
      } else {
        // DynamicTheme.of(context).setBrightness(Brightness.light);
        statusBarColorBloc.setBrightness(lightThemeData.primaryColor);

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor:
              statusBarColorBloc.brightnessValue, // status bar color
        ));

        return lightThemeData;
      }
    }, themedWidgetBuilder: (context, theme) {
      return MaterialApp(
        title: 'World Holidays',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: WorldHolidays(),
      );
    });
  }

  void buildSetSystemUIOverlayStyle(context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          // Theme.of(context).brightness == Brightness.light
          //     ? Brightness.light
          //     :
          Brightness.light,
      // systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black, // status bar color
    ));
  }
}

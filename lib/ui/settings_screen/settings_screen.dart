import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../resources/custom_cs_header.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _index;

  

  @override
  Widget build(BuildContext context) {

    print(Theme.of(context).brightness.toString());
    
    switchBrightness() {

      if (Theme.of(context).brightness == Brightness.dark) {
        DynamicTheme.of(context).setBrightness(Brightness.light);
      } else {
        DynamicTheme.of(context).setBrightness(Brightness.dark);
      }
      
    }

    _index = Theme.of(context).brightness == Brightness.light ? 0 : 1;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Settings'),
        // automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
            ),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: CupertinoSettings(
        items: <Widget>[
          // CSHeader('Brightness'),
          // CSWidget(
          //     new CupertinoSlider(
          //       value: _slider,
          //       onChanged: (double value) {
          //         setState(() {
          //           _slider = value;
          //         });
          //       },
          //     ),
          //     style: CSWidgetStyle(icon: Icon(FontAwesomeIcons.sun))),
          // CSControl(
          //   'Auto brightness',
          //   CupertinoSwitch(
          //     value: _switch,
          //     onChanged: (bool value) {
          //       setState(() {
          //         _switch = value;
          //       });
          //     },
          //   ),
          //   style: CSWidgetStyle(icon: Icon(FontAwesomeIcons.sun)),
          // ),
          CustomCSHeader(
            'Theme',
          ),
          CSSelection(
            ['Day mode', 'Night mode'],
            (int value) {
              setState(() {
                switchBrightness();
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          // CSHeader(""),
          // CSControl('Loading...', CupertinoActivityIndicator()),
          // CSButton(CSButtonType.DEFAULT, "Licenses", () {
          // print("It works!");
          // }),
          // CSHeader(""),
          // CSButton(CSButtonType.DESTRUCTIVE, "Delete all data", () {}),
        ],
      ),
    );
  }
}

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

import '../../resources/custom_cs_header.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _index;

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
            ),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: CupertinoSettings(
        items: <Widget>[
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
        ],
      ),
    );
  }
}

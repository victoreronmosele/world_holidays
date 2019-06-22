import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';

class StatusBarColorBloc extends BlocBase {
  final statusBarColor = BehaviorSubject<Color>();

  void dispose() {
    statusBarColor.close();
  }

  get brightnessValue {
    return statusBarColor.value;
  }

  setBrightness(Color color) {
    statusBarColor.sink.add(color);
  }
}


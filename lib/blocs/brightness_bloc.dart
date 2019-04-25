import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StatusBarColorBloc {
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

final statusBarColorBloc = StatusBarColorBloc();

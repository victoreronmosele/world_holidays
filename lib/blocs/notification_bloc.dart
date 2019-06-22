import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';

class NotificationBloc extends BlocBase{
  final flutterLocalNotificationsPlugin =
      BehaviorSubject<FlutterLocalNotificationsPlugin>();

  Function(FlutterLocalNotificationsPlugin)
      get setFlutterLocalNotificationsPlugin =>
          flutterLocalNotificationsPlugin.sink.add;

  void dispose() {
    flutterLocalNotificationsPlugin.close();
  }

  FlutterLocalNotificationsPlugin getFlutterLocalNotificationsPlugin() =>
      flutterLocalNotificationsPlugin.value;
}

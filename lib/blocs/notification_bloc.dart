import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBloc {
  final flutterLocalNotificationsPlugin = BehaviorSubject<FlutterLocalNotificationsPlugin>();

  Function(FlutterLocalNotificationsPlugin) get setFlutterLocalNotificationsPlugin => flutterLocalNotificationsPlugin.sink.add;

  void dispose() {
    flutterLocalNotificationsPlugin.close();
  }

  FlutterLocalNotificationsPlugin getFlutterLocalNotificationsPlugin() => flutterLocalNotificationsPlugin.value;
  
  
}

final notificationBloc = NotificationBloc();


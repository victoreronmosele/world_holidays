import 'package:world_holidays/blocs/brightness_bloc.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:world_holidays/blocs/holiday_reminder_bloc.dart';
import 'package:world_holidays/blocs/notification_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';

class AppBloc extends BlocBase {
  HolidayBloc _holidayBloc;
  HolidayReminderBloc _holidayReminderBloc;
  NotificationBloc _notificationBloc;
  StatusBarColorBloc _statusBarColorBloc;

  AppBloc() {
    _holidayBloc = HolidayBloc();
    _holidayReminderBloc = HolidayReminderBloc();
    _notificationBloc = NotificationBloc();
    _statusBarColorBloc = StatusBarColorBloc();
  }

  HolidayBloc get holidayBloc => _holidayBloc;
  HolidayReminderBloc get holidayReminderBloc => _holidayReminderBloc;
  NotificationBloc get notificationBloc => _notificationBloc;
  StatusBarColorBloc get statusBarColorBloc => _statusBarColorBloc;

  @override
  void dispose() {
    _holidayBloc?.dispose();
    _holidayReminderBloc?.dispose();
    _notificationBloc?.dispose();
    _statusBarColorBloc?.dispose();
  }
}

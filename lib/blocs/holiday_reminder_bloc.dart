import 'package:world_holidays/models/holiday_reminder.dart';
import 'package:world_holidays/resources/months_color.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HolidayReminderBloc {
  final _repository = Repository();
  final holidayReminderList = BehaviorSubject<List<HolidayReminder>>();
  final monthIndexToHolidayReminderListMapSubject =
      BehaviorSubject<Map<String, List<HolidayReminder>>>();

  HolidayReminderBloc() {
    getHolidayReminderList();
  }

  void dispose() async {
    holidayReminderList.close();
    monthIndexToHolidayReminderListMapSubject.close();
  }

  get monthIndexToHolidayReminderListMap {
    getHolidayReminderList();

    Map<String, List<HolidayReminder>> monthIndexToHolidayReminderListMap =
        Map();

    if (holidayReminderList.value == null) {
      monthIndexToHolidayReminderListMapSubject.sink
          .add(monthIndexToHolidayReminderListMap);
      return monthIndexToHolidayReminderListMapSubject;
    }

    monthToColorMap.keys.forEach((String month) {
      List<HolidayReminder> holidayReminderListInMonth = [];

      holidayReminderList.value.forEach((HolidayReminder holidayReminder) {
        if (holidayReminder.monthString == month) {
          holidayReminderListInMonth.add(holidayReminder);
        }
      });

      if (holidayReminderListInMonth.isNotEmpty) {
        monthIndexToHolidayReminderListMap
            .addAll({month: holidayReminderListInMonth});
      }
    });

    monthIndexToHolidayReminderListMapSubject.sink
        .add(monthIndexToHolidayReminderListMap);

    return monthIndexToHolidayReminderListMapSubject;
  }

  getHolidayReminderList() async {
    holidayReminderList.sink.add(await _repository.getAllHolidayReminders());
  }

  addNewHoliday(HolidayReminder holidayReminder) =>
      _repository.addNewHolidayReminder(holidayReminder);

  deleteHolidayReminder(String id) => _repository.deleteHolidayReminder(id);

  deleteAllHolidayReminders() => _repository.deleteAllHolidayReminders();

  Future<bool> isHolidayInReminderList(String id) =>
      _repository.isHolidayInReminderList(id);
}

final holidayReminderBloc = HolidayReminderBloc();

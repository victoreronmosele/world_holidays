import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_reminder.dart';
import 'package:world_holidays/resources/months_color.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HolidayReminderBloc extends BlocBase {
  final _repository = Repository();
  final holidayReminderList = BehaviorSubject<List<HolidayReminder>>();
  final monthIndexToHolidayReminderListMapSubject =
      BehaviorSubject<Map<String, List<HolidayReminder>>>();

  HolidayReminderBloc() {
    getHolidayReminderList();
  }

  void dispose() {
    holidayReminderList.close();
    monthIndexToHolidayReminderListMapSubject.close();
  }

  get monthIndexToHolidayReminderListMap {
    getHolidayReminderList();

    Map<String, List<HolidayReminder>> monthIndexToHolidayReminderListMap =
        Map();

    if (holidayReminderList.value == null ||
        holidayReminderList.value.isEmpty) {
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
        holidayReminderListInMonth
            .sort((a, b) => int.parse(a.date).compareTo(int.parse(b.date)));
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

  addNewHoliday(HolidayReminder holidayReminder) {
    _repository.addNewHolidayReminder(holidayReminder);
  }

  deleteHolidayReminder(String id, String month) {
    _repository.deleteHolidayReminder(id);
    List<HolidayReminder> newHolidayReminderList = holidayReminderList.value;

    newHolidayReminderList.removeWhere((holidayReminder) {
      return holidayReminder.id == id;
    });
    holidayReminderList.sink.add(newHolidayReminderList);

    Map<String, List<HolidayReminder>> newMonthIndexToHolidayReminderListMap =
        monthIndexToHolidayReminderListMapSubject.value;
    if (newMonthIndexToHolidayReminderListMap != null &&
        newMonthIndexToHolidayReminderListMap.isNotEmpty) {
      newMonthIndexToHolidayReminderListMap[month]
          .removeWhere((holidayReminder) {
        return holidayReminder.id == id;
      });

      newMonthIndexToHolidayReminderListMap.update(
          month,
          (monthIndexToHolidayReminderListMap) =>
              newMonthIndexToHolidayReminderListMap[month]);

      monthIndexToHolidayReminderListMapSubject.sink
          .add(newMonthIndexToHolidayReminderListMap);
    }
  }

  deleteAllHolidayReminders() {
    _repository.deleteAllHolidayReminders();
    holidayReminderList.sink.add([]);
    monthIndexToHolidayReminderListMapSubject.sink.add({});
  }

  Future<bool> isHolidayInReminderList(String id) =>
      _repository.isHolidayInReminderList(id);
}


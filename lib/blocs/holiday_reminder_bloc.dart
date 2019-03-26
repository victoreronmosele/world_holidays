import 'package:world_holidays/models/holiday_reminder.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HolidayReminderBloc {
  final _repository = Repository();
  final holidayReminderList = BehaviorSubject<List<HolidayReminder>>();

  HolidayReminderBloc() {
    getHolidayReminderList();
  }

  void dispose() async {
    holidayReminderList.close();
  }

  get holidayReminderListValue {
    getHolidayReminderList();
    return holidayReminderList.stream;
  }

  getHolidayReminderList() async {
    holidayReminderList.sink.add(await _repository.getAllHolidayReminders());
  }

  addNewHoliday(HolidayReminder holidayReminder) =>
      _repository.addNewHolidayReminder(holidayReminder);

  deleteHolidayReminder(String id) => _repository.deleteHolidayReminder(id);

  deleteAllHolidayReminders() => _repository.deleteAllHolidayReminders();

  Future<bool> isHolidayInReminderList(String id) => _repository.isHolidayInReminderList(id);
}

final holidayReminderBloc = HolidayReminderBloc();

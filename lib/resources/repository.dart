import 'package:world_holidays/models/holiday_data.dart';
import 'calendarific_provider.dart';

class Repository {
  final _calendarificProvider = CalendarificProvider();

  Future<HolidayData> getHolidays(String countryCode) =>
      _calendarificProvider.getHolidays(countryCode);
}

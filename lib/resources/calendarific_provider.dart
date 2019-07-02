import 'package:http/http.dart' as http;
import 'package:world_holidays/models/holiday_data.dart';
import 'dart:convert';
import 'package:world_holidays/internal/keys.dart';

class CalendarificProvider {
  String apiKey =
      calendarificApiKey; //Please get your API key from calendarific.com :)
  String currentYear = DateTime.now().year.toString();

  Future<HolidayData> getHolidays(String countryCode) async {
    final response = await http.get(
        'https://calendarific.com/api/v2/holidays?&api_key=$apiKey&country=$countryCode&year=$currentYear');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      //response.body['response'] returns a Map if there is available holidays and 
      //an empty list if no holidays are available
      if (((jsonData as Map)['response'] is Map) == false) {
        throw Exception('No holidays available');
      }

      return HolidayData.fromJson(jsonData);
    } else {
      throw Exception('Failed to get holidays');
    }
  }
}

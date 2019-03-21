import 'package:http/http.dart' as http;
import 'package:world_holidays/models/holiday_data.dart';
import 'dart:convert';
import 'package:world_holidays/internal/keys.dart';

class CalendarificProvider {
  String apiKey = calendarificApiKey; //Please get your API key from calendarific.com :)
  

  Future<HolidayData> getHolidays(String countryCode) async {
    
    final response = await http.get(
        'https://calendarific.com/api/v2/holidays?country=${countryCode ?? "NG"}&year=2019&api_key=$apiKey');

    if (response.statusCode == 200) {
      final jsonData = await json.decode(response.body);
      return HolidayData.fromJson(jsonData);
    } else {
      throw Exception("Failed to get holidays");
    }
  }
}

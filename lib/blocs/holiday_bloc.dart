import 'package:flutter/material.dart';
import 'package:world_holidays/models/holiday_data.dart';
import '../resources/repository.dart';
import 'package:world_holidays/resources/months_color.dart';

class HolidayBloc {
  final _repository = Repository();

  Future<HolidayData> getHolidays(String countryCode) {
    return _repository.getHolidays(countryCode);
  }

  Map<String, List<Holiday>> getMapOfMonthToHolidayList(
      AsyncSnapshot snapshot) {

    Map<String, List<Holiday>> monthToHolidayListMap =
        Map<String, List<Holiday>>();

    HolidayData holidayData = snapshot.data;


    if (holidayData == null ){
      return monthToHolidayListMap;
    }
    Response response = holidayData.response;

    List<Holiday> holidays = response.holidays;

    monthToColorMap.forEach((month, color){
      
      int monthPosition = monthToColorMap.keys.toList().indexOf(month) + 1;
      

        List<Holiday> monthHolidaysList = List();
          holidays.forEach((holiday) {

            
        if (holiday.date.datetime.month == monthPosition) {
          
          monthHolidaysList.add(holiday);
        }
        monthToHolidayListMap[month] = monthHolidaysList;
      });

    });

    return monthToHolidayListMap;
  }
}

final holidayBloc = HolidayBloc();

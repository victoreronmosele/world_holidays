import 'package:flutter/material.dart';
import 'package:world_holidays/models/holiday_data.dart';
import '../resources/repository.dart';
import 'package:world_holidays/resources/months_color.dart';
import 'package:rxdart/rxdart.dart';

class HolidayBloc {
  final _repository = Repository();
  final currentSelectedCountryCode = BehaviorSubject<String>();
  final currentSelectedCountryName = BehaviorSubject<String>();
  final holidays = BehaviorSubject<HolidayData>();

  get holidaysValue {
    if (holidays.value != null) {
      return holidays;
    } else {
      getHolidays();
      return holidays;
    }
  }

  getHolidays() async {
    holidays.sink.add(
        await _repository.getHolidays(currentSelectedCountryCodeValue.value));
  }

  refreshHolidays() {
    holidays.sink.add(null);

    getHolidays();
  }

  void dispose() {
    currentSelectedCountryCode.close();
    currentSelectedCountryName.close();
    holidays.close();
  }

  BehaviorSubject<String> get currentSelectedCountryCodeValue {
    if (currentSelectedCountryCode == null) {
      currentSelectedCountryCode.sink.add("US");

      return currentSelectedCountryCode;
    }

    return currentSelectedCountryCode;
  }

  setCurrentSelectedCountryCode(String countryCode) {
    currentSelectedCountryCode.sink.add(countryCode);
  }

  BehaviorSubject<String> get currentSelectedCountryNameValue {
    if (currentSelectedCountryName == null) {
      currentSelectedCountryName.sink.add("United States");
      return currentSelectedCountryName;
    }

    return currentSelectedCountryName;
  }

  setCurrentSelectedCountryName(String countryName) {
    currentSelectedCountryName.sink.add(countryName);
  }

  Map<String, List<Holiday>> getMapOfMonthToHolidayList(
      AsyncSnapshot snapshot) {
    Map<String, List<Holiday>> monthToHolidayListMap =
        Map<String, List<Holiday>>();

    HolidayData holidayData = snapshot.data;

    if (holidayData == null) {
      return monthToHolidayListMap;
    }
    Response response = holidayData.response;

    List<Holiday> holidays = response.holidays;

    monthToColorMap.forEach((month, color) {
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

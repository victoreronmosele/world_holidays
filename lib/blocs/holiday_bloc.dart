import 'package:flutter/material.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_data.dart';
import '../resources/repository.dart';
import 'package:world_holidays/resources/months_color.dart';
import 'package:rxdart/rxdart.dart';

class HolidayBloc extends BlocBase {
  final _repository = Repository();
  final currentSelectedCountryCode = BehaviorSubject<String>();
  final currentSelectedCountryName = BehaviorSubject<String>();
  final holidays = BehaviorSubject<HolidayData>();

  get holidaysValue {
    if (holidays.value != null) {
      return holidays;
    } else if (currentSelectedCountryCodeValue.value != null) {
      getHolidays();
      return holidays;
    }
  }

  getHolidays() async {
    try {
      holidays.sink.add(
          await _repository.getHolidays(currentSelectedCountryCodeValue.value));
    } catch (e) {
      print('Exception caught');
      print(e);
      holidays.sink.addError(e);
    }
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
    if (currentSelectedCountryCode.value == null) {
      _repository.getCountryCode().then((countryCode) {
        currentSelectedCountryCode.sink.add(countryCode);
        return currentSelectedCountryCode;
      });
    }

    return currentSelectedCountryCode;
  }

  BehaviorSubject<String> get currentSelectedCountryNameValue {
    if (currentSelectedCountryName.value == null) {
      _repository.getCountryName().then((countryName) {
        currentSelectedCountryName.sink.add(countryName);
        return currentSelectedCountryName;
      });
    }

    return currentSelectedCountryName;
  }

  setCurrentCountryDetails(
      {@required String countryCode, @required String countryName}) async {
    await _repository.setCountryName(countryName);
    await _repository.setCountryCode(countryCode);

    currentSelectedCountryName.sink.add(countryName);
    currentSelectedCountryCode.sink.add(countryCode);

    refreshHolidays();
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

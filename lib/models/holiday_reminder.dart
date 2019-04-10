import 'dart:convert';
import 'package:meta/meta.dart';

HolidayReminder clientFromJson(String str) {
  final jsonData = json.decode(str);
  return HolidayReminder.fromMap(jsonData);
}

String clientToJson(HolidayReminder data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class HolidayReminder {
  //TODO Include year in dates
  String id;
  String name;
  String description;
  String country;
  int monthIndex;
  String monthString;
  String date;
  String dayOfTheWeek;
  bool isExpanded;
  int notificationsChannelId;
  

  HolidayReminder({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.country,
    @required this.monthIndex,
    @required this.monthString,
    @required this.date,
    @required this.dayOfTheWeek,
    this.isExpanded = false,
    @required this.notificationsChannelId,
  });

  factory HolidayReminder.fromMap(Map<String, dynamic> json) =>
      new HolidayReminder(
        id: json["id"],
        name: json["name"],
        description: json['description'],
        country: json["country"],
        monthIndex: json['monthIndex'],
        monthString: json['monthString'],
        date: json['date'],
        dayOfTheWeek: json['dayOfTheWeek'],
        notificationsChannelId: json['notificationsChannelId'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        'description': description,
        'country': country,
        'monthIndex': monthIndex,
        'monthString': monthString,
        'date': date,
        'dayOfTheWeek': dayOfTheWeek,
        'notificationsChannelId': notificationsChannelId,
      };
}

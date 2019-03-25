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
  String id;
  String name;
  String description;
  String holidayDate;
  String country;

  HolidayReminder({
     @required this.id,
     @required this.name,
    @required this.description,
    @required this.holidayDate,
    @required this.country,
  });

  factory HolidayReminder.fromMap(Map<String, dynamic> json) => new HolidayReminder(
        id: json["id"],
        name: json["name"],
        description: json['description'],
        holidayDate : json['holidayDate'],
        country : json["country"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        'description':description,
        'holidayDate':holidayDate,
        'country':country,
      };
}
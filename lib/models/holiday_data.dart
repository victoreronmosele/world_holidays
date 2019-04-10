// To parse this JSON data, do
//
//     final holidayData = holidayDataFromJson(jsonString);

import 'dart:convert';

HolidayData holidayDataFromJson(String str) {
  final jsonData = json.decode(str);
  return HolidayData.fromJson(jsonData);
}

String holidayDataToJson(HolidayData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class HolidayData {
  Response response;

  HolidayData({
    this.response,
  });

  factory HolidayData.fromJson(Map<String, dynamic> json) {
    return new HolidayData(
      response:
          // Response.fromJson
          Response.fromJson(json["response"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
      };
}

class Response {
  List<Holiday> holidays;

  Response({
    this.holidays,
  });

  factory Response.fromJson(Map<String, dynamic> json) => new Response(
        holidays: new List<Holiday>.from(
            json["holidays"].map((x) => Holiday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "holidays": new List<dynamic>.from(holidays.map((x) => x.toJson())),
      };
}

class Holiday {
  String name;
  String description;
  Date date;
  List<String> type;
  String locations;
  // List states;
  bool isExpanded;

  Holiday({
    this.name,
    this.description,
    this.date,
    this.type,
    this.locations,
    // this.states,
    this.isExpanded = false,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) => new Holiday(
        name: json["name"],
        description: json["description"],
        date: Date.fromJson(json["date"]),
        type: new List<String>.from(json["type"].map((x) => x)),
        locations: json["locations"],
        // states: json["states"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "date": date.toJson(),
        "type": new List<dynamic>.from(type.map((x) => x)),
        "locations": locations,
        // "states": states,
      };
}

class Date {
  String iso;
  Datetime datetime;

  Date({
    this.iso,
    this.datetime,
  });

  factory Date.fromJson(Map<String, dynamic> json) => new Date(
        iso: json["iso"],
        datetime: Datetime.fromJson(json["datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "iso": iso,
        "datetime": datetime.toJson(),
      };
}

class Datetime {
  int year;
  int month;
  int day;

  Datetime({
    this.year,
    this.month,
    this.day,
  });

  factory Datetime.fromJson(Map<String, dynamic> json) => new Datetime(
        year: json["year"],
        month: json["month"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
      };
}

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:world_holidays/models/holiday_reminder.dart';

class SQLiteProvider {
  SQLiteProvider._();
  static final SQLiteProvider db = SQLiteProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ReminderDatabase.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE HolidayReminder ('
          //Primary Key is TEXT becuase the api returns no id
          //And so holiday name + country is used as text
          'id TEXT PRIMARY KEY,'
          'name TEXT,'
          'description TEXT,'
          'country TEXT,'
          'monthIndex INTEGER,'
          'monthString TEXT,'
          'date TEXT,'
          'dayOfTheWeek TEXT,'
          'notificationsChannelId INTEGER'
          ')');
    });

}

addNewHoliday (HolidayReminder holidayReminder) async {
  final db = await database;
  var res =await db.insert("HolidayReminder", holidayReminder.toMap());
  return res;
}

 getHoliday(String id) async {
    final db = await database;
    var res = await db.query("HolidayReminder", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? HolidayReminder.fromMap(res.first) : null;
  }

  Future<List<HolidayReminder>> getAllHolidays() async {
    final db = await database;
    var res = await db.query("HolidayReminder");
    List<HolidayReminder> list =
        res.isNotEmpty ? res.map((c) => HolidayReminder.fromMap(c)).toList() : [];
    return list;
  }

  deleteHoliday(String id) async {
    final db = await database;
    return db.delete("HolidayReminder", where: "id = ?", whereArgs: [id]);
  }

  deleteAllHolidays() async {
    final db = await database;
    db.rawDelete("Delete from HolidayReminder");
  }

  updateHoliday(HolidayReminder newHolidayReminder) async {
    final db = await database;
    var res = await db.update("Client", newHolidayReminder.toMap(),
        where: "id = ?", whereArgs: [newHolidayReminder.id]);
    return res;
  }




  Future<bool> isHolidayInReminderList(String id) async {
    
    bool isHolidayInReminderList;

    List<HolidayReminder> holidayReminderList =  await getAllHolidays();

    isHolidayInReminderList =  holidayReminderList.any(
      (test) {
        return test.id ==id;
      }
      
    );

    return isHolidayInReminderList;
  }

}

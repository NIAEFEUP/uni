import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/schedule_option.dart';

/// Manages the app's Schedule Planner database.
/// 
/// This database stores information about the schedule planning that the user
/// wants to keep track of.
class AppPlannedScheduleDatabase extends AppDatabase {

  static final schedulePlannerTable = '''CREATE TABLE scheduleoption(id INTEGER PRIMARY KEY AUTOINCREMENT, scheduleName TEXT, preference INTEGER)''';
  static final selectedCoursesPlanner ='''CREATE TABLE selectedCourses(id INTEGER PRIMARY KEY AUTOINCREMENT, schedule INTEGER NOT NULL, class INTEGER NOT NULL, FOREIGN KEY (schedule) REFERENCES scheduleoption,FOREIGN KEY (class) REFERENCES class);''';
  static final classes ='''CREATE TABLE class(id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT NOT NULL, courseCode TEXT NOT NULL)''';

  static final createScript = [
    schedulePlannerTable,
    selectedCoursesPlanner,
    classes
  ];

  AppPlannedScheduleDatabase()
      : super('scheduleplanner.db', createScript);

  Future<int> getClassID(String className, String courseCode) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
        'class',
        columns: ['id'],
        where: '"className" = ?, "courseCode" = ?',
        whereArgs: [className, courseCode]
    );

    if (maps.isNotEmpty) {
      return maps[0]['id'];
    }

    return -1;
  }

  /// Adds a schedule option to this database.
  createSchedule(ScheduleOption scheduleOption) async {
    final Map<String, String>
      classesSelected = scheduleOption.classesSelected;
    final int scheduleID = await this.insertInDatabase(
      'scheduleoption',
      {
        'scheduleName': scheduleOption.name,
        'preference': 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    classesSelected.forEach((courseUnitCode, courseUnitClassName) async {

      int courseUnitClassID =
        this.getClassID(courseUnitClassName, courseUnitCode) as int;

      if (courseUnitClassID == -1) {
        courseUnitClassID = await this.insertInDatabase(
          'class',
          {
            'className': courseUnitClassName,
            'courseCode': courseUnitCode
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await this.insertInDatabase(
        'selectedCourses',
        {
          'schedule': scheduleID,
          'class': courseUnitClassID
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    });
  }

  Future<List<ScheduleOption>> getScheduleOptions() async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> scheduleOptions = await db.rawQuery(
        'SELECT * FROM "scheduleoption"'
    );

    for(var option in scheduleOptions) {
      int optionID = option['id'];



    }
  }
}

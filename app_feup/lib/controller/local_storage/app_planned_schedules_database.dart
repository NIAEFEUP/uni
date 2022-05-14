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
  static final classes ='''CREATE TABLE class(id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT NOT NULL, courseAbrv TEXT NOT NULL)''';

  static final createScript = [
    schedulePlannerTable,
    selectedCoursesPlanner,
    classes
  ];

  AppPlannedScheduleDatabase()
      : super('scheduleplanner.db', createScript);

  Future<int> getClassID(String className, String courseAbrv) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
        'class',
        columns: ['id'],
        where: '"className" = ?, "courseAbrv" = ?',
        whereArgs: [className, courseAbrv]
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

    classesSelected.forEach((courseUnitAbrv, courseUnitClassName) async {

      int courseUnitClassID =
        this.getClassID(courseUnitClassName, courseUnitAbrv) as int;

      if (courseUnitClassID == -1) {
        courseUnitClassID = await this.insertInDatabase(
          'class',
          {
            'className': courseUnitClassName,
            'courseAbrv': courseUnitAbrv
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

    final List<Map<String, dynamic>> scheduleOptionsQuery = await db.rawQuery(
        'SELECT * FROM "scheduleoption"'
    );
  
    final List<ScheduleOption> scheduleOptions = 
      List.filled(0, ScheduleOption());
    
    for(var option in scheduleOptionsQuery) {
      int optionID = option['id'];

      final List<Map<String, dynamic>> optionInfo = await db.rawQuery(
          '''SELECT * FROM "scheduleoption"
             JOIN "selectedCourses" ON "scheduleoption".id = "selectedCourses".schedule
             JOIN "class" ON "selectedCourses".class = "class".id
             WHERE "scheduleoption".id = 1;'''
      );
      // course unit abbreviation  to course unit class name

      Map<String, String> selectedCourses = Map<String, String>();

      for (var selectedCourse in optionInfo) {
          selectedCourses[selectedCourse["courseAbrv"]] =
            selectedCourse["className"];
      }

      scheduleOptions.add(
          ScheduleOption
              .generate(
              option["name"],
              selectedCourses
          ));

    }
  }
}

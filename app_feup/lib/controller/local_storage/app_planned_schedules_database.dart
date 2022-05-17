import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:collection/collection.dart';

/// Manages the app's Schedule Planner database.
/// 
/// This database stores information about the schedule planning that the user
/// wants to keep track of.
class AppPlannedScheduleDatabase extends AppDatabase {

  static final schedulePlannerTable = '''CREATE TABLE scheduleoption(id INTEGER PRIMARY KEY AUTOINCREMENT, scheduleName TEXT, preference INTEGER)''';
  static final selectedCoursesPlanner ='''CREATE TABLE selectedCourses(id INTEGER PRIMARY KEY AUTOINCREMENT, schedule INTEGER NOT NULL, class INTEGER NOT NULL, FOREIGN KEY (schedule) REFERENCES scheduleoption,FOREIGN KEY (class) REFERENCES class)''';
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
        where: '"className" = ? AND "courseAbrv" = ?',
        whereArgs: [className, courseAbrv]
    );

    if (maps.isNotEmpty) {
      return maps[0]['id'];
    }

    return -1;
  }

  /// Adds a schedule option to this database.
  Future<int> createSchedule() async {
    final Database db = await this.getDatabase();

    return await db.insert(
      'scheduleoption',
      {
        'scheduleName': 'Novo Horário',
        'preference': 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Saves a schedule information
  saveSchedule(ScheduleOption scheduleOption) async{
    final Database db = await this.getDatabase();
    final classesSelected = scheduleOption.classesSelected;
    final scheduleID = scheduleOption.id;
    final scheduleName = scheduleOption.name;
    final preference = scheduleOption.preference;

    print(classesSelected);
    print(scheduleID);
    print(scheduleName);
    print(preference);

    db.update('scheduleoption', {
      'scheduleName': scheduleName,
      'preference': preference
    }, where: '"id" = ?',
    whereArgs: [scheduleID]);

    await db.delete(
        'selectedCourses',
        where: '"schedule" = ?',
        whereArgs: [scheduleOption.id]
    );

    classesSelected.forEach((courseUnitAbrv, courseUnitClassName) async {
      int courseUnitClassID =
        await this.getClassID(courseUnitClassName, courseUnitAbrv);
      if (courseUnitClassID == -1) {
        courseUnitClassID = await db.insert(
          'class',
          {
            'className': courseUnitClassName,
            'courseAbrv': courseUnitAbrv
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await db.insert(
        'selectedCourses',
        {
          'schedule': scheduleID,
          'class': courseUnitClassID
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    });
  }

  reorderOptions(List<ScheduleOption> scheduleOptions) async {
    final Database db = await this.getDatabase();

    scheduleOptions.forEachIndexed((index, element) {
      db.update('scheduleoption', {
        'preference': index + 1
      }, where: '"id" = ?',
          whereArgs: [element.id]);
    });
  }

  deleteOption(ScheduleOption scheduleOption) async {
    final Database db = await this.getDatabase();

    await db.delete('scheduleoption',
      where: '"id" = ?',
      whereArgs: [scheduleOption.id]);
  }

  Future<List<ScheduleOption>> getScheduleOptions() async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> scheduleOptionsQuery = await db.rawQuery(
        'SELECT * FROM "scheduleoption"'
    );
  
    final List<ScheduleOption> scheduleOptions = 
      List.empty(growable: true);
    
    for(var option in scheduleOptionsQuery) {
      int optionID = option['id'];
      String query = '''SELECT * FROM "scheduleoption"
             JOIN "selectedCourses" ON "scheduleoption".id = "selectedCourses".schedule
             JOIN "class" ON "selectedCourses".class = "class".id
             WHERE "scheduleoption".id = :opt:;''';

      query = query.replaceFirst(':opt:', optionID.toString());

      final List<Map<String, dynamic>> optionInfo = await db.rawQuery(query);

      // course unit abbreviation  to course unit class name
      Map<String, String> selectedCourses = Map<String, String>();

      for (var selectedCourse in optionInfo) {
          selectedCourses[selectedCourse['courseAbrv']] =
            selectedCourse['className'];
      }

      scheduleOptions.add(
          ScheduleOption
              .generate(
              option['id'],
              option['scheduleName'],
              selectedCourses,
              option['preference']
          ));

    }

    scheduleOptions.sort((a,b) {
      return a.preference.compareTo(b.preference);
    });

    return scheduleOptions;
  }

  Future<void> deleteDB() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('scheduleoption');
    await db.delete('selectedCourses');
    await db.delete('class');
  }
}

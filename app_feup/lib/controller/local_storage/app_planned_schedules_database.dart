import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/class_registration_model.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/schedule_option.dart';

/// Manages the app's Schedule Planner database.
///
/// This database stores information about the schedule planning that the user
/// wants to keep track of.
class AppPlannedScheduleDatabase extends AppDatabase {
  static final curricularUnitChoice =
      '''CREATE TABLE curricularUnitChoice(id INTEGER PRIMARY KEY AUTOINCREMENT, semester INTEGER, courseAbrv TEXT NOT NULL, UNIQUE(semester, courseAbrv))''';
  static final schedulePlannerTable =
      '''CREATE TABLE scheduleoption(id INTEGER PRIMARY KEY AUTOINCREMENT, semester INTEGER, scheduleName TEXT, preference INTEGER)''';
  static final selectedCoursesPlanner =
      '''CREATE TABLE selectedCourses(id INTEGER PRIMARY KEY AUTOINCREMENT, schedule INTEGER NOT NULL, class INTEGER NOT NULL, FOREIGN KEY (schedule) REFERENCES scheduleoption,FOREIGN KEY (class) REFERENCES class)''';
  static final classes =
      '''CREATE TABLE class(id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT NOT NULL, courseAbrv TEXT NOT NULL)''';

  static final createScript = [
    curricularUnitChoice,
    schedulePlannerTable,
    selectedCoursesPlanner,
    classes
  ];

  AppPlannedScheduleDatabase() : super('scheduleplanner.db', createScript);

  Future<List<String>> getSelectedCourseUnits(Semester semester) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
        'curricularUnitChoice',
        columns: ['courseAbrv'],
        where: '"semester" = ?',
        whereArgs: [semester.toInt().toString()]);

    final List<String> abbreviations = List.empty(growable: true);

    for (var row in maps) {
      abbreviations.add(row['courseAbrv']);
    }

    return abbreviations;
  }

  insertSelectedCourseUnit(CourseUnit courseUnit) async {
    final Database db = await this.getDatabase();
    await db.insert(
      'curricularUnitChoice',
      {
        'semester': SemesterUtils.fromCode(courseUnit.semesterCode).toInt(),
        'courseAbrv': courseUnit.abbreviation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeSelectedCourseUnit(CourseUnit courseUnit) async {
    final Database db = await this.getDatabase();

    await db.delete('curricularUnitChoice',
        where: '"courseAbrv" = ? AND "semester" = ?',
        whereArgs: [
          courseUnit.abbreviation,
          SemesterUtils.fromCode(courseUnit.semesterCode).toInt()
        ]);
  }

  Future<int> getClassID(String className, String courseAbrv) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('class',
        columns: ['id'],
        where: '"className" = ? AND "courseAbrv" = ?',
        whereArgs: [className, courseAbrv]);

    if (maps.isNotEmpty) {
      return maps[0]['id'];
    }

    return -1;
  }

  /// Adds a schedule option to this database.
  Future<int> createSchedule(
      String name, int preference, Semester semester) async {
    final Database db = await this.getDatabase();

    return await db.insert(
      'scheduleoption',
      {
        'scheduleName': name,
        'preference': preference,
        'semester': semester.toInt().toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Saves a schedule information
  saveSchedule(ScheduleOption scheduleOption) async {
    final Database db = await this.getDatabase();
    final classesSelected = scheduleOption.classesSelected;
    final scheduleID = scheduleOption.id;
    final scheduleName = scheduleOption.name;
    final preference = scheduleOption.preference;

    db.update('scheduleoption',
        {'scheduleName': scheduleName, 'preference': preference},
        where: '"id" = ?', whereArgs: [scheduleID]);

    await db.delete('selectedCourses',
        where: '"schedule" = ?', whereArgs: [scheduleID]);

    classesSelected.forEach((courseUnitAbrv, courseUnitClassName) async {
      int courseUnitClassID =
          await this.getClassID(courseUnitClassName, courseUnitAbrv);
      if (courseUnitClassID == -1) {
        courseUnitClassID = await db.insert(
          'class',
          {'className': courseUnitClassName, 'courseAbrv': courseUnitAbrv},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await db.insert(
        'selectedCourses',
        {'schedule': scheduleID, 'class': courseUnitClassID},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  reorderOptions(List<ScheduleOption> scheduleOptions) async {
    final Database db = await this.getDatabase();

    scheduleOptions.forEachIndexed((index, element) {
      db.update('scheduleoption', {'preference': index + 1},
          where: '"id" = ?', whereArgs: [element.id]);
    });
  }

  deleteOption(ScheduleOption scheduleOption) async {
    final Database db = await this.getDatabase();

    await db.delete('scheduleoption',
        where: '"id" = ?', whereArgs: [scheduleOption.id]);
  }

  Future<List<ScheduleOption>> getScheduleOptions(Semester semester) async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> scheduleOptionsQuery = await db.rawQuery(
        '''SELECT * FROM "scheduleoption" WHERE semester = :sem:;'''
            .replaceFirst(':sem:', semester.toInt().toString()));

    final List<ScheduleOption> scheduleOptions = List.empty(growable: true);

    for (var option in scheduleOptionsQuery) {
      final int optionID = option['id'];
      String query = '''SELECT * FROM "scheduleoption"
             JOIN "selectedCourses" ON "scheduleoption".id = "selectedCourses".schedule
             JOIN "class" ON "selectedCourses".class = "class".id
             WHERE "scheduleoption".id = :opt:;''';

      query = query.replaceFirst(':opt:', optionID.toString());

      final List<Map<String, dynamic>> optionInfo = await db.rawQuery(query);

      // course unit abbreviation  to course unit class name
      final Map<String, String> selectedCourses = Map<String, String>();

      for (var selectedCourse in optionInfo) {
        selectedCourses[selectedCourse['courseAbrv']] =
            selectedCourse['className'];
      }

      scheduleOptions.add(ScheduleOption(
          id: option['id'],
          name: option['scheduleName'],
          classesSelected: selectedCourses,
          preference: option['preference']));
    }

    scheduleOptions.sort((a, b) {
      return a.preference.compareTo(b.preference);
    });

    return scheduleOptions;
  }

  Future<void> deleteDB() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('curricularUnitChoice');
    await db.delete('scheduleoption');
    await db.delete('selectedCourses');
    await db.delete('class');
  }

  Future<Semester>getScheduleOptionSemester(ScheduleOption option) async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> query = await db.query('scheduleoption',
        columns: ['semester'],
        where: '"id" = ?',
        whereArgs: [option.id]);
    return SemesterUtils.fromInt(query[0]['semester']);
  }
}

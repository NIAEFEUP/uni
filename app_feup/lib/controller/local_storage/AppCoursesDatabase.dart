import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/model/entities/Course.dart';
import 'package:sqflite/sqflite.dart';

class AppCoursesDatabase extends AppDatabase {

  AppCoursesDatabase():super('courses.db', 'CREATE TABLE courses(id INTEGER, fest_id INTEGER, name TEXT, abbreviation TEXT, currYear TEXT, firstEnrollment INTEGER, state TEXT)');

  saveNewCourses(List<Course> courses) async {
    await _deleteCourses();
    await _insertCourses(courses);
  }

  Future<List<Course>> courses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Courses.
    final List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    return List.generate(maps.length, (i) {
      return Course.secConstructor(
          maps[i]['id'],
          maps[i]['fest_id'],
          maps[i]['name'],
          maps[i]['abbreviation'],
          maps[i]['currYear'],
          maps[i]['firstEnrollment'],
          maps[i]['state']
      );
    });
  }

  Future<void> _insertCourses(List<Course> courses) async {

    for (Course course in courses)
      await insertInDatabase(
        'courses',
        course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> _deleteCourses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('courses');
  }

  void saveCoursesStates(Map<String, String> states) async{
    final Database db = await this.getDatabase();

    // Retrieve stored courses
    List<Course> courses = await this.courses();

    // For each course, save its state
    for (Course course in courses) {
      await db.update(
        'courses',
        {'state' : states[course.name]},
        where: "id = ?",
        whereArgs: [course.id],
      );
    }

  }
}
import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/exam.dart';

/// Manages the app's Exams database.
///
/// This database stores information about the user's exams.
/// See the [Exam] class to see what data is stored in this database.
class AppExamsDatabase extends NoSQLDatabase<Exam> {
  AppExamsDatabase() : super('exams', version: 1);
}

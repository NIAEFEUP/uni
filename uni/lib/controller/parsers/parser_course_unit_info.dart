import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';

Future<CourseUnitSheet> parseCourseUnitSheet(http.Response response) async {
  return CourseUnitSheet(
      {'goals': 'Grelhar', 'program': 'A arte da grelha. Cenas.'});
}

Future<List<CourseUnitClass>> parseCourseUnitClasses(
    http.Response response) async {
  return [
    CourseUnitClass(["José", "Gomes"]),
    CourseUnitClass(["Mendes", "Pereira"]),
  ];
}

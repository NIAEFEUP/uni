import 'package:uni/model/entities/course_units/course_unit_file.dart';

class CourseUnitFileDirectory {
  CourseUnitFileDirectory(this.folderName, this.files);

  final String folderName;
  final List<CourseUnitFile> files;
}

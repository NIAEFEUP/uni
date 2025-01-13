import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  static List<CourseUnitFileDirectory> data = [
    CourseUnitFileDirectory(
      'folder1',
      [
        CourseUnitFile('file1_2024-01-01', 'url1', 'code1'),
        CourseUnitFile('file2_2024-01-01', 'url2', 'code2'),
        CourseUnitFile('file3_2024-01-01', 'url3', 'code3'),
      ],
    ),
    CourseUnitFileDirectory(
      'folder2',
      [
        CourseUnitFile('file4_2024-01-01', 'url4', 'code4'),
        CourseUnitFile('file5_2024-01-01', 'url5', 'code5'),
      ],
    ),
    CourseUnitFileDirectory(
      'folder3',
      [
        CourseUnitFile('file6_2024-01-01', 'url6', 'code6'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CourseUnitFilesView(data);
  }
}

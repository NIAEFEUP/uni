import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files_row.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';

class CourseUnitFilesView extends StatelessWidget {
  const CourseUnitFilesView(this.files, {super.key});
  final List<Map<String, List<CourseUnitFile>>> files;

  @override
  Widget build(BuildContext context) {
    final cards = files
        .expand(
          (file) => file.entries
              .where((item) => item.value.isNotEmpty)
              .map((item) => _buildCard(item.key, item.value)),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView(children: cards),
    );
  }

  CourseUnitInfoCard _buildCard(String folder, List<CourseUnitFile> files) {
    return CourseUnitInfoCard(
      folder,
      Column(
        children: files.map(CourseUnitFilesRow.new).toList(),
      ),
    );
  }
}

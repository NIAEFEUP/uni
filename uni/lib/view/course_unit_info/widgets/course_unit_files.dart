import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files_row.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';

class CourseUnitFilesView extends StatelessWidget {
  const CourseUnitFilesView(this.files, {super.key});
  final List<CourseUnitFileDirectory> files;

  @override
  Widget build(BuildContext context) {
    final cards = files
        .where((element) => element.files.isNotEmpty)
        .map((e) => _buildCard(e.folderName, e.files))
        .toList();

    return cards.isEmpty
        ? Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(S.of(context).no_files_found),
            ),
          )
        : Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              children: cards,
            ),
          );
  }

  CourseUnitInfoCard _buildCard(String folder, List<CourseUnitFile> files) =>
      CourseUnitInfoCard(
        folder,
        Column(
          children: files.map(CourseUnitFilesRow.new).toList(),
        ),
      );
}

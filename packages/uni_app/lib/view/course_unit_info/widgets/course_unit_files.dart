import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni_ui/cards/file_card.dart';
import 'package:uni_ui/cards/folder_card.dart';

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

  FileCard _buildFileCard(CourseUnitFile file) {
    // Extract the extension and discard the date.
    final parts = file.name.split('_');
    final dateAndExtension = parts.last;
    final extension = dateAndExtension.split('.').last;
    final filename = parts.sublist(0, parts.length - 1).join('_');
    return FileCard(
      filename: filename,
      extension: extension,
    );
  }

  FolderCard _buildCard(String folder, List<CourseUnitFile> files) {
    return FolderCard(
      title: folder,
      children: files
          .map(
            _buildFileCard,
          )
          .toList(),
    );
  }
}

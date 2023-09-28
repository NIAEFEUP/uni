import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:open_file_plus/open_file_plus.dart';

class CourseUnitFilesRow extends StatelessWidget {
  const CourseUnitFilesRow(this.file, {Key? key}) : super(key: key);

  final CourseUnitFile file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.picture_as_pdf),
          const SizedBox(width: 1),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                file.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => openFile(file),
          ),
        ],
      ),
    );
  }

  Future<void> openFile(CourseUnitFile course_unit_file) async {
    final response = course_unit_file.bodyBytes;

    final String fileName = course_unit_file.name + '.pdf';

    final downloadsDir = await getDownloadsDirectory();
    final downloadPath = '${downloadsDir!.path}/$fileName';

    final file = File(downloadPath);
    if (!await file.exists()) {
      await file.create();
    }
    await file.writeAsBytes(response);
    await OpenFile.open(file.path.toString());
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';

class CourseUnitFilesRow extends StatelessWidget {
  const CourseUnitFilesRow(this.file, {super.key});

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
            icon: const Icon(Icons.download),
            onPressed: () => openFile(file),
          ),
        ],
      ),
    );
  }

  Future<void> openFile(CourseUnitFile unitFile) async {
    final response = unitFile.bodyBytes;

    final fileName = '${unitFile.name}.pdf';

    final downloadDir = (await getTemporaryDirectory()).path;
    final downloadPath = '$downloadDir/$fileName';

    final file = File(downloadPath);
    if (!file.existsSync()) {
      file.createSync();
    }
    await file.writeAsBytes(response);
    await OpenFile.open(file.path);
  }
}

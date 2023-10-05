import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

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
            onPressed: () => openFile(context, file),
          ),
        ],
      ),
    );
  }

  Future<void> openFile(BuildContext context, CourseUnitFile unitFile) async {
    final session = context.read<SessionProvider>().session;

    final result = await loadFileFromStorageOrRetrieveNew(
      '${unitFile.name}.pdf',
      unitFile.url,
      session,
      headers: {'pct_id': unitFile.fileCode},
    );

    await OpenFile.open(result!.path);
  }
}

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
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
      fileCode: file.fileCode,
      fullname: file.name,
      url: file.url,
      onOpenFile: openFile,
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

  Future<void> openFile(
    BuildContext context,
    String fileCode,
    String fullname,
    String url,
    VoidCallback startAnimation,
    VoidCallback stopAnimation,
  ) async {
    final session = context.read<SessionProvider>().state;

    final result = await loadFileFromStorageOrRetrieveNew(
      fullname,
      url,
      session,
      headers: {'pct_id': fileCode},
    );

    if (result?.path != null) {
      final resultType = await OpenFile.open(result!.path);
      if (context.mounted) {
        handleFileOpening(resultType.type, context);
      }
    } else {
      if (context.mounted) {
        await ToastMessage.error(context, S.of(context).download_error);
      }
    }

    stopAnimation();
  }

  void handleFileOpening(ResultType resultType, BuildContext context) {
    switch (resultType) {
      case ResultType.done:
        ToastMessage.success(
          context,
          S.of(context).successful_open,
        );
      case ResultType.error:
        ToastMessage.error(
          context,
          S.of(context).open_error,
        );
      case ResultType.noAppToOpen:
        ToastMessage.warning(
          context,
          S.of(context).no_app,
        );
      case ResultType.permissionDenied:
        ToastMessage.warning(context, S.of(context).permission_denied);
      case ResultType.fileNotFound:
        ToastMessage.error(context, S.of(context).download_error);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/cards/file_card.dart';
import 'package:uni_ui/cards/folder_card.dart';

import 'course_unit_no_files.dart';

class CourseUnitFilesView extends ConsumerWidget {
  const CourseUnitFilesView(this.files, {super.key});
  final List<CourseUnitFileDirectory> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.read(sessionProvider);

    return sessionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (session) {
        if (session == null) {
          return const Center(child: Text('No session available.'));
        }

        final cards = files
            .where((element) => element.files.isNotEmpty)
            .map(
              (e) => _buildCard(context, e.folderName, e.files, session),
            ) // pass session
            .toList();

        return cards.isEmpty
            ? LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: constraints.maxHeight,
                    padding: const EdgeInsets.only(bottom: 120),
                    child: const Center(child: NoFilesWidget()),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: ListView(children: cards),
              );
      },
    );
  }

  FileCard _buildFileCard(
    BuildContext context,
    CourseUnitFile file,
    Session session,
  ) {
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
      onOpenFile: (context, _, _, _, startAnimation, stopAnimation) {
        return openFile(
          context,
          session,
          file.fileCode,
          file.name,
          file.url,
          startAnimation,
          stopAnimation,
        );
      },
    );
  }

  FolderCard _buildCard(
    BuildContext context,
    String folder,
    List<CourseUnitFile> files,
    Session session,
  ) {
    return FolderCard(
      title: folder,
      children: files
          .map((file) => _buildFileCard(context, file, session))
          .toList(),
    );
  }

  Future<void> openFile(
    BuildContext context,
    Session session,
    String fileCode,
    String fullname,
    String url,
    VoidCallback startAnimation,
    VoidCallback stopAnimation,
  ) async {
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
        ToastMessage.success(context, S.of(context).successful_open);
      case ResultType.error:
        ToastMessage.error(context, S.of(context).open_error);
      case ResultType.noAppToOpen:
        ToastMessage.warning(context, S.of(context).no_app);
      case ResultType.permissionDenied:
        ToastMessage.warning(context, S.of(context).permission_denied);
      case ResultType.fileNotFound:
        ToastMessage.error(context, S.of(context).download_error);
    }
  }
}

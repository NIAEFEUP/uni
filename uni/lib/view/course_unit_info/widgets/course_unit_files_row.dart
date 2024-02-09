import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/common_widgets/pulse_animation.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class CourseUnitFilesRow extends StatefulWidget {
  const CourseUnitFilesRow(this.file, {super.key});

  final CourseUnitFile file;

  @override
  State<StatefulWidget> createState() {
    return CourseUnitFilesRowState();
  }
}

class CourseUnitFilesRowState extends State<CourseUnitFilesRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.picture_as_pdf),
          const SizedBox(width: 1),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..repeat(reverse: true);
                openFile(context, widget.file);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: PulseAnimation(
                  description: widget.file.name,
                  controller: _controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openFile(BuildContext context, CourseUnitFile unitFile) async {
    final session = context.read<SessionProvider>().state!;

    try {
      final result = await loadFileFromStorageOrRetrieveNew(
        unitFile.name,
        unitFile.url,
        session,
        headers: {'pct_id': unitFile.fileCode},
      );
      await OpenFile.open(result!.path);
    } catch (e) {
      if (context.mounted) {
        await ToastMessage.error(
          context,
          S.of(context).load_error,
        );
      }
    }
    _controller.reset();
  }
}

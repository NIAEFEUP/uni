import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/person_info.dart';

class StudentInfoModal extends ConsumerWidget {
  const StudentInfoModal(this.student, {super.key});
  final CourseUnitStudent student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider.select((value) => value.value!));
    return ModalDialog(
      children: [
        Column(
          children: [
            FutureBuilder<File?>(
              builder:
                  (context, snapshot) => ModalPersonInfo(
                    name: student.name,
                    image:
                        snapshot.hasData && snapshot.data != null
                            ? Image(image: FileImage(snapshot.data!))
                            : Image.asset(
                              'assets/images/profile_placeholder.png',
                            ),
                  ),
              future: ProfileNotifier.fetchOrGetCachedProfilePicture(
                session,
                studentNumber: student.number,
              ),
            ),
            if (student.mail != '')
              GestureDetector(
                onTap:
                    () => launchUrlWithToast(context, 'mailto:${student.mail}'),
                child: ModalInfoRow(
                  title: 'Email',
                  description: student.mail,
                  icon: UniIcons.email,
                  trailing: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

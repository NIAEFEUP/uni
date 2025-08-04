import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
// import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
// import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/person_info.dart';

class ProfessorInfoModal extends StatelessWidget {
  const ProfessorInfoModal(this.professor, {super.key});
  final Professor professor;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    return ModalDialog(
      children: [
        FutureBuilder<File?>(
          builder:
              (context, snapshot) => ModalPersonInfo(
                name: professor.name,
                image:
                    snapshot.hasData && snapshot.data != null
                        ? Image(image: FileImage(snapshot.data!))
                        : Image.asset('assets/images/profile_placeholder.png'),
              ),
          future: ProfileProvider.fetchOrGetCachedProfilePicture(
            session,
            studentNumber: int.parse(professor.code),
          ),
        ),
        // Professor model hasn't the necessary fields
        /*
        ModalInfoRow(
          title: 'Email',
          description: '[email-professor@up.pt]',
          icon: UniIcons.email,
          trailing: UniIcon(
            UniIcons.caretRight,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const ModalInfoRow(
          title: 'Sala',
          description: '[sala]',
          icon: UniIcons.location,
        ),
        */
      ],
    );
  }
}

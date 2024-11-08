import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni_ui/modal/modal.dart';

class ProfessorInfoModal extends StatelessWidget {
  const ProfessorInfoModal(this.professor, {super.key});
  final MapEntry<int, Professor> professor;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    return ModalDialog(
      children: [
        Column(
          children: [
            FutureBuilder<File?>(
              builder: (context, snapshot) => CircleAvatar(
                radius: 60,
                backgroundImage: snapshot.hasData && snapshot.data != null
                    ? FileImage(snapshot.data!) as ImageProvider
                    : const AssetImage(
                        'assets/images/profile_placeholder.png',
                      ),
              ),
              future: ProfileProvider.fetchOrGetCachedProfilePicture(
                session,
                studentNumber: int.parse(professor.value.code),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              professor.value.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ],
    );
  }
}

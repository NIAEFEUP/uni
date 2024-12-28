import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';

class ProfessorInfoModal extends StatelessWidget {
  const ProfessorInfoModal(this.professor, {super.key});
  final Professor professor;

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
                studentNumber: int.parse(professor.code),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              professor.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Opacity(
              opacity: 0.25,
              child: Divider(color: Colors.grey),
            ),
            Row(
              children: [
                PhosphorIcon(
                  UniIcons.email,
                  color: Theme.of(context).colorScheme.primary,
                  duotoneSecondaryColor: Colors.red,
                  size: 32,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '[email-professor@domain.com]',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const Opacity(
              opacity: 0.25,
              child: Divider(color: Colors.grey),
            ),
            Row(
              children: [
                PhosphorIcon(
                  UniIcons.location,
                  color: Theme.of(context).colorScheme.primary,
                  duotoneSecondaryColor: Colors.red,
                  size: 32,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sala: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '[sala]',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

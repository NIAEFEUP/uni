import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/professor_info_provider.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/person_info.dart';
import 'shimmer_info_row.dart';

class ProfessorInfoModal extends ConsumerWidget {
  const ProfessorInfoModal(this.professor, {super.key});
  final Professor professor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value!;
    final baseUrls = NetworkRouter.getBaseUrlsFromSession(session);

    return ModalDialog(
      children: [
        FutureBuilder<File?>(
          builder: (context, snapshot) => ModalPersonInfo(
            name: professor.name,
            image: snapshot.hasData && snapshot.data != null
                ? Image(image: FileImage(snapshot.data!))
                : Image.asset('assets/images/profile_placeholder.png'),
          ),
          future: ProfileNotifier.fetchOrGetCachedProfilePicture(
            session,
            studentNumber: int.parse(professor.code),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final infoAsyncValue = ref.watch(professorInfoProvider(professor));
            return infoAsyncValue.when(
              data: (info) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ModalInfoRow(
                    title: S.of(context).email,
                    description: info.email ?? '—',
                    icon: UniIcons.email,
                    trailing: info.email != null
                        ? UniIcon(
                            UniIcons.caretRight,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const SizedBox(),
                    onPressed: info.email != null
                        ? () => launchUrlWithToast(
                            context,
                            'mailto:${info.email}',
                          )
                        : null,
                  ),
                  ModalInfoRow(
                    title: S.of(context).room,
                    description: info.rooms.isNotEmpty
                        ? info.rooms.join(', ')
                        : '—',
                    icon: UniIcons.location,
                  ),
                ],
              ),
              loading: () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerInfoRow(
                    title: S.of(context).email,
                    icon: UniIcons.email,
                  ),
                  ShimmerInfoRow(
                    title: S.of(context).room,
                    icon: UniIcons.location,
                  ),
                ],
              ),
              error: (err, stack) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ModalInfoRow(
                    title: S.of(context).email,
                    description: '—',
                    icon: UniIcons.email,
                  ),
                  ModalInfoRow(
                    title: S.of(context).room,
                    description: '—',
                    icon: UniIcons.location,
                  ),
                ],
              ),
            );
          },
        ),
        if (baseUrls.isNotEmpty)
          ModalInfoRow(
            title: S.of(context).schedule,
            icon: UniIcons.lecture,
            trailing: UniIcon(
              UniIcons.caretRight,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              '/${NavigationItem.navProfessorSchedule.route}',
              arguments: professor,
            ),
          ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/person_info.dart';

class _ProfessorExtraInfo {
  const _ProfessorExtraInfo({this.email, this.rooms = const []});

  final String? email;
  final List<String> rooms;
}

class ProfessorInfoModal extends ConsumerWidget {
  const ProfessorInfoModal(this.professor, {super.key});
  final Professor professor;

  Iterable<String> _splitAndCleanRooms(String raw) sync* {
    for (final token in raw.split(RegExp(r'\s*,\s*|\s*;\s*'))) {
      final value = token
          .trim()
          .replaceAll(
            RegExp(
              r'^(Salas?|Gabinetes?|Rooms?)\s*:?\s*',
              caseSensitive: false,
            ),
            '',
          )
          .replaceAll(RegExp(r'^[sS]\s*:\s*'), '')
          .trim();
      if (value.isNotEmpty) {
        yield value;
      }
    }
  }

  List<String> _dedupeRooms(Iterable<String> roomValues) {
    final normalizedToDisplay = <String, String>{};

    for (final raw in roomValues) {
      for (final room in _splitAndCleanRooms(raw)) {
        final key = room.replaceAll(RegExp(r'\s+'), '').toUpperCase();
        normalizedToDisplay.putIfAbsent(key, () => room);
      }
    }

    return normalizedToDisplay.values.toList();
  }

  Future<_ProfessorExtraInfo> _fetchProfessorExtraInfo(
    Session session,
    List<String> baseUrls,
  ) async {
    final email = professor.institutionalEmail;
    final rooms = {...professor.rooms};

    if (email != null && rooms.isNotEmpty) {
      return _ProfessorExtraInfo(email: email, rooms: rooms.toList());
    }

    for (final baseUrl in baseUrls) {
      final profileUrl =
          '${baseUrl}func_geral.formview?p_codigo=${professor.code}';
      try {
        final response = await NetworkRouter.getWithCookies(
          profileUrl,
          {},
          session,
        );
        final document = parse(response.body);

        var parsedEmail = email;

        for (final link in document.querySelectorAll('a[href]')) {
          final href = link.attributes['href'] ?? '';
          if (!href.toLowerCase().startsWith('mailto:')) {
            continue;
          }
          final value = href
              .substring('mailto:'.length)
              .split('?')
              .first
              .trim();
          if (value.contains('@')) {
            parsedEmail = value;
            break;
          }
        }

        // SIGARRA obfuscates @ as an HTML entity; read onclick via DOM so
        // entities are decoded, then extract local+domain from the JS pattern.
        if (parsedEmail == null) {
          for (final link in document.querySelectorAll('a[onclick]')) {
            final onclick = link.attributes['onclick'] ?? '';
            final m = RegExp(
              r"lto'\+':([A-Za-z0-9._%+\-]+)'\+secure\+'([A-Za-z0-9.\-]+\.[A-Za-z]{2,})'",
            ).firstMatch(onclick);
            if (m != null) {
              parsedEmail = '${m.group(1)}@${m.group(2)}';
              break;
            }
          }
        }

        if (parsedEmail == null) {
          continue;
        }

        for (final roomLink in document.querySelectorAll(
          'a[href*="instal_geral.espaco_view"]',
        )) {
          final room = roomLink.text.trim();
          if (room.isNotEmpty) {
            rooms.add(room);
          }
        }

        final roomLabelRegex = RegExp(
          r'(Sala|Salas|Gabinete|Gabinetes|Room|Rooms)\s*:?\s*(.+)',
          caseSensitive: false,
        );

        for (final row in document.querySelectorAll('tr')) {
          final cells = row.querySelectorAll('th,td');
          if (cells.length < 2) {
            continue;
          }

          final label = cells.first.text.trim();
          if (!RegExp(
            '(Sala|Gabinete|Room)',
            caseSensitive: false,
          ).hasMatch(label)) {
            continue;
          }

          final value = cells[1].text.trim();
          if (value.isNotEmpty) {
            rooms.add(value);
          }
        }

        for (final element in document.querySelectorAll('p,li,span,div')) {
          final text = element.text.trim().replaceAll('\n', ' ');
          final match = roomLabelRegex.firstMatch(text);
          final value = match?.group(2)?.trim();
          if (value != null && value.isNotEmpty && value.length <= 64) {
            rooms.add(value);
          }
        }

        return _ProfessorExtraInfo(
          email: parsedEmail,
          rooms: _dedupeRooms(rooms),
        );
      } catch (_) {
        continue;
      }
    }

    return _ProfessorExtraInfo(email: email, rooms: _dedupeRooms(rooms));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value!;
    final baseUrls = NetworkRouter.getBaseUrlsFromSession(session);
    final scheduleUrl = baseUrls.isNotEmpty
        ? '${baseUrls[0]}hor_geral.docentes_view?pv_doc_codigo=${professor.code}'
        : null;

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
        FutureBuilder<_ProfessorExtraInfo>(
          future: baseUrls.isNotEmpty
              ? _fetchProfessorExtraInfo(session, baseUrls)
              : Future.value(
                  _ProfessorExtraInfo(
                    email: professor.institutionalEmail,
                    rooms: professor.rooms,
                  ),
                ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShimmerInfoRow(
                    title: S.of(context).email,
                    icon: UniIcons.email,
                  ),
                  _ShimmerInfoRow(
                    title: S.of(context).room,
                    icon: UniIcons.location,
                  ),
                ],
              );
            }

            final info = snapshot.data!;
            return Column(
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
                      ? () =>
                            launchUrlWithToast(context, 'mailto:${info.email}')
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
            );
          },
        ),
        if (scheduleUrl != null)
          ModalInfoRow(
            title: S.of(context).schedule,
            icon: UniIcons.lecture,
            trailing: UniIcon(
              UniIcons.caretRight,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => launchUrlWithToast(context, scheduleUrl),
          ),
      ],
    );
  }
}

class _ShimmerInfoRow extends StatelessWidget {
  const _ShimmerInfoRow({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListTile(
        dense: true,
        leading: UniIcon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(height: 10, width: 140, color: Colors.white),
        ),
      ),
    );
  }
}

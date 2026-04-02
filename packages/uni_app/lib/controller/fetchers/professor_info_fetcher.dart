import 'package:html/parser.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/session/flows/base/session.dart';

class ProfessorInfoFetcher {
  Future<Professor> fetchProfessorInfo(
    Professor professor,
    Session session,
    List<String> baseUrls,
  ) async {
    final email = professor.institutionalEmail;
    final rooms = {...professor.rooms};

    if (email != null && rooms.isNotEmpty) {
      return Professor(
        code: professor.code,
        name: professor.name,
        classes: professor.classes,
        institutionalEmail: email,
        rooms: rooms.toList(),
        picture: professor.picture,
        isRegent: professor.isRegent,
      );
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

        return Professor(
          code: professor.code,
          name: professor.name,
          classes: professor.classes,
          institutionalEmail: parsedEmail,
          rooms: _dedupeRooms(rooms),
          picture: professor.picture,
          isRegent: professor.isRegent,
        );
      } catch (_) {
        continue;
      }
    }

    return Professor(
      code: professor.code,
      name: professor.name,
      classes: professor.classes,
      institutionalEmail: email,
      rooms: _dedupeRooms(rooms),
      picture: professor.picture,
      isRegent: professor.isRegent,
    );
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
}

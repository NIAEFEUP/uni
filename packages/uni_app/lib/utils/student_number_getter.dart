import 'package:uni/session/flows/base/session.dart';

int getStudentNumber(Session session) {
  return int.tryParse(session.username.replaceAll(RegExp(r'\D'), '')) ?? 0;
}

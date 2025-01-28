import 'package:uni/model/providers/startup/session_provider.dart';

int getStudentNumber(SessionProvider sessionProvider) {
  return int.tryParse(
        sessionProvider.state!.username.replaceAll(RegExp(r'\D'), ''),
      ) ??
      0;
}

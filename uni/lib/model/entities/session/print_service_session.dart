import 'package:uni/model/entities/session/session.dart';

class PrintServiceSession extends AbstractSession{
  PrintServiceSession(
      {super.authenticated = false,
      super.cookies = '',
      super.persistentSession = false});
}

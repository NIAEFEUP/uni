import 'package:uni/controller/session/session.dart';

abstract class SessionRequest {
  Future<Session> perform();
}

import 'package:uni/controller/session/session.dart';

abstract class SessionRequest<T extends Session> {
  Future<T> perform();
}

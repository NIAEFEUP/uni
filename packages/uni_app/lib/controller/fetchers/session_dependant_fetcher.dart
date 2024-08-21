import 'package:uni/session/base/session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

import 'package:uni/session/session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

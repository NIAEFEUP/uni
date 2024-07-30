import 'package:uni/controller/session/session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

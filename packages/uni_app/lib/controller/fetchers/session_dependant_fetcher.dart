import 'package:uni/session/flows/base/session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

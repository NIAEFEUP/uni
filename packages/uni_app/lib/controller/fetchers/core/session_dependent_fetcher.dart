import 'package:uni/session/flows/base/session.dart';

abstract class SessionDependentFetcher {
  List<String> getEndpoints(Session session);
}

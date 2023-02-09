import 'package:uni/model/entities/session/sigarra_session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

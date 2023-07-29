import 'package:uni/model/entities/session.dart';

abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

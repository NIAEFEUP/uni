import 'package:uni/model/entities/session.dart';

// TODO(luisd): apparently, it's not a good practice defining an abstract class
//  with just one function, it's better to typedef the function, we can disable
//  rule if we want a more java-like experience.

//ignore: one_member_abstracts
abstract class SessionDependantFetcher {
  List<String> getEndpoints(Session session);
}

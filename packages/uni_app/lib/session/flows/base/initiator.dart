import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:uni/session/flows/base/request.dart';

/// In the authentication flow, the [SessionInitiator] is the component
/// responsible for handling the initial intention of the user to authenticate
/// in the app.
///
/// When the user is in the login screen, each login method will have its own
/// initiator. An initiator only needs to be able to create a [SessionRequest]
/// and is not responsible for the actual authentication of the user.
abstract class SessionInitiator {
  FutureOr<SessionRequest> initiate([http.Client? httpClient]);
}

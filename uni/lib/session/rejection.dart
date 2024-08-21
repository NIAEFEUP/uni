import 'dart:async';

import 'package:uni/session/request.dart';

abstract interface class SessionRejectionHandler {
  FutureOr<void> onSessionRejected(SessionRequest request);
}

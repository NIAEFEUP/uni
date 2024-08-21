import 'dart:async';

import 'package:uni/session/base/request.dart';

abstract interface class SessionRejectionHandler {
  FutureOr<void> onSessionRejected(SessionRequest request);
}

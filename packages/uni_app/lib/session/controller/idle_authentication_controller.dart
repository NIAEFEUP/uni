import 'package:uni/session/controller/authentication_controller.dart';
import 'package:uni/session/flows/base/session.dart';

class IdleAuthenticationController extends AuthenticationController {
  IdleAuthenticationController(this._session);

  final Session _session;

  @override
  Future<AuthenticationSnapshot> get snapshot => Future.value(
        AuthenticationSnapshot(
          _session,
          invalidate: () async {},
        ),
      );
}

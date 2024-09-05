import 'package:uni/session/controller/authentication_controller.dart';
import 'package:uni/session/exception.dart';

class ThrowingAuthenticationController extends AuthenticationController {
  @override
  Future<AuthenticationSnapshot> get snapshot =>
      throw const AuthenticationException(
        'AuthenticationController is in idle',
      );
}

import 'package:uni/sigarra/endpoints/html/authentication/login/login.dart';
import 'package:uni/sigarra/endpoints/html/authentication/logout/logout.dart';
import 'package:uni/utils/lazy.dart';

class SigarraHtmlAuthentication {
  final _logout = Lazy(() => const Logout());
  Logout get logout => _logout.value;

  final _login = Lazy(() => const Login());
  Login get login => _login.value;
}

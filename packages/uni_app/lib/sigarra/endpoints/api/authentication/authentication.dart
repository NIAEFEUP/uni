import 'package:uni/sigarra/endpoints/api/authentication/login/login.dart';
import 'package:uni/utils/lazy.dart';

class SigarraApiAuthentication {
  final _login = Lazy(() => const Login());
  Login get login => _login.value;
}

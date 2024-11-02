import 'package:uni/sigarra/endpoints/oidc/token/token.dart';
import 'package:uni/utils/lazy.dart';

class SigarraOidc {
  final _token = Lazy(Token.new);
  Token get token => _token.value;
}

import 'package:uni/sigarra/endpoints/api/authentication/authentication.dart';
import 'package:uni/utils/lazy.dart';

class SigarraApi {
  final _authentication = Lazy(SigarraApiAuthentication.new);
  SigarraApiAuthentication get authentication => _authentication.value;
}

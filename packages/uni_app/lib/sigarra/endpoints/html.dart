import 'package:uni/sigarra/endpoints/html/authentication.dart';
import 'package:uni/utils/lazy.dart';

class SigarraHtml {
  final _authentication = Lazy(SigarraHtmlAuthentication.new);
  SigarraHtmlAuthentication get authentication => _authentication.value;
}

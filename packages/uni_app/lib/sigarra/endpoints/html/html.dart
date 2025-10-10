import 'package:uni/sigarra/endpoints/html/authentication/authentication.dart';
import 'package:uni/sigarra/endpoints/html/home/home.dart';
import 'package:uni/utils/lazy.dart';

class SigarraHtml {
  final _authentication = Lazy(SigarraHtmlAuthentication.new);
  SigarraHtmlAuthentication get authentication => _authentication.value;

  final _home = Lazy(Home.new);
  Home get home => _home.value;
}

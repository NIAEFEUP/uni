import 'package:html/parser.dart';

bool isPasswordExpired(String htmlBody) {
  final document = parse(htmlBody);
  final alerts = document.querySelectorAll('.aviso-invalidado');
  return alerts.length >= 2 && alerts[1].text.contains('expirad');
}

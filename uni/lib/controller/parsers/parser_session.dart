import 'package:html/parser.dart';

bool isPasswordExpired(String htmlBody){
  final document = parse(htmlBody);
  final alerts = document.querySelectorAll('.aviso-invalidado');
  if(alerts.length < 2) return false;
  return alerts[1].text.contains('A sua senha de acesso encontra-se expirada');
}

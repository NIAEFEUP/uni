import 'package:html/parser.dart';

bool isPasswordExpired(String htmlBody){
  final document = parse(htmlBody);
  final alert = document.querySelector('.aviso-invalidado');
  if(alert == null) return false;
  return alert.text.contains('A sua senha de acesso encontra-se expirada');
}

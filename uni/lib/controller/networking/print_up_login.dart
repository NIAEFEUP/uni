import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/actions.dart';

/// returns the user email with up200000000@up.pt format
String getStudentEmail(String username) {
  //Extracts only the number from username
  final regex = RegExp(r'\d+');
  final String? studentNumber = regex.stringMatch(username);
  if (studentNumber == null) throw Exception('No student number!');

  return 'up$studentNumber@up.pt';
}

/// Returns the cookie for print.up.pt
Future<String> getPrintUpAuthCookie(String username, String password) async {
  const printUrl = 'https://print.up.pt';
  const url1 = '$printUrl/user';

  final getResponse =
      await http.get(Uri.parse(url1)).timeout(const Duration(seconds: 10));

  const url = '$printUrl/app';

  final Map<String, String> headers = <String, String>{};
  headers['content-type'] = 'application/x-www-form-urlencoded';
  headers['origin'] = printUrl;
  headers['cookie'] = getResponse.headers['set-cookie'] ?? '';
  if (headers['cookie'] == '') throw Exception('No cookie found!');

  final email = getStudentEmail(username);

  String payload =
      'service=direct%2F1%2FHome%2F%24Form&sp=S0&Form0=%24Hidden%240%2C%24Hidden%241%2CinputUsername%2CinputPassword%2C%24Submit%240%2C%24PropertySelection&%24Hidden%240=true&%24Hidden%241=X&%24Submit%240=Entrar&%24PropertySelection=pt_PT';
  payload += '&inputUsername=$email&inputPassword=$password';

  final postResponse =
      await http.post(Uri.parse(url), headers: headers, body: payload);

  String cookie = postResponse.headers['set-cookie'] ?? '';
  cookie = cookie.split('JSESSIONID=')[1];
  cookie = cookie.split(';')[0];
  if (cookie == '') throw Exception('No cookie found!');

  return 'JSESSIONID=$cookie;';
}

Future loginPrintUp(Session session, String password) async {
  final cookie = await getPrintUpAuthCookie(session.studentNumber, password);
  session.cookies += cookie;
  return (Store<AppState> store){
    store.dispatch(SaveLoginDataAction(session));
  };
}
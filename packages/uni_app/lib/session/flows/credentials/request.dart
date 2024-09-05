import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_session.dart';
import 'package:uni/model/entities/login_exceptions.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/credentials/session.dart';

class CredentialsSessionRequest extends SessionRequest {
  CredentialsSessionRequest({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  Future<CredentialsSession> perform([http.Client? httpClient]) async {
    // TODO (limwa): Use client
    // We need to login to fetch the faculties, so perform a temporary login.
    final tempSession = await NetworkRouter.login(username, password);

    if (tempSession == null) {
      // Get the fail reason.
      final responseHtml =
          await NetworkRouter.loginInSigarra(username, password, ['feup']);

      if (isPasswordExpired(responseHtml)) {
        throw ExpiredCredentialsException();
      } else {
        throw WrongCredentialsException();
      }
    }

    final faculties = await getStudentFaculties(tempSession);

    final session = CredentialsSession(
      username: tempSession.username,
      cookies: tempSession.cookies,
      faculties: faculties,
      password: password,
    );

    return session;
  }
}

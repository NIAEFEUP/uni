import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/credentials/session.dart';
import 'package:uni/sigarra/endpoints/api/api.dart';
import 'package:uni/sigarra/endpoints/html/authentication/login/response.dart';
import 'package:uni/sigarra/endpoints/html/html.dart';
import 'package:uni/sigarra/options.dart';

class CredentialsSessionRequest extends SessionRequest {
  CredentialsSessionRequest({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  Future<CredentialsSession> perform([http.Client? httpClient]) async {
    final client = httpClient ?? http.Client();

    // We need to login to fetch the faculties, so perform a temporary login.
    final tempSession = await _loginWithApi(username, password, client);

    if (tempSession == null) {
      // Get the fail reason.
      final failureReason =
          await _getLoginFailureReason(username, password, client);

      // FIXME(limwa): convey the reason to the user
      if (failureReason == LoginFailureReason.expiredCredentials) {
        throw const AuthenticationException(
          'Failed to authenticate user',
          AuthenticationExceptionType.expiredCredentials,
        );
      } else {
        throw const AuthenticationException(
          'Failed to authenticate user',
          AuthenticationExceptionType.wrongCredentials,
        );
      }
    }

    final faculties = await getStudentFaculties(tempSession, client);

    final session = CredentialsSession(
      username: tempSession.username,
      cookies: tempSession.cookies,
      faculties: faculties,
      password: password,
    );

    return session;
  }

  Future<CredentialsSession?> _loginWithApi(
    String username,
    String password,
    http.Client httpClient,
  ) async {
    final api = SigarraApi();
    const tempFaculty = 'feup';

    final loginResponse = await api.authentication.login.call(
      username: username,
      password: password,
      options: FacultyRequestOptions(faculty: tempFaculty, client: httpClient),
    );

    if (!loginResponse.success) {
      return null;
    }

    final info = loginResponse.asSuccessful();
    return CredentialsSession(
      username: info.username,
      password: password,
      cookies: info.cookies,
      faculties: [tempFaculty],
    );
  }

  Future<LoginFailureReason> _getLoginFailureReason(
    String username,
    String password,
    http.Client httpClient,
  ) async {
    final html = SigarraHtml();
    final response = await html.authentication.login.call(
      username: username,
      password: password,
      options: FacultyRequestOptions(client: httpClient),
    );

    final error = response.asFailed();
    return error.reason;
  }
}

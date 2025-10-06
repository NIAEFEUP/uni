import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/http/client/cookie.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/credentials/session.dart';
import 'package:uni/sigarra/endpoints/html/authentication/login/response.dart';
import 'package:uni/sigarra/endpoints/html/html.dart';
import 'package:uni/sigarra/options.dart';

// Faculty where all of the temporary sessions are created.
// The faculty must display the student photo on the home page.
const tempFaculty = 'feup';

const genericAuthenticationException = AuthenticationException(
  'Failed to authenticate user',
);

class CredentialsSessionRequest extends SessionRequest {
  CredentialsSessionRequest({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Future<CredentialsSession> perform([http.Client? httpClient]) async {
    final client = httpClient ?? http.Client();

    // We need to login to fetch the username and faculties,
    // so perform a temporary login.
    final loginResponse = await _loginOrFail(username, password, client);
    final actualUsername = await _getUsername(loginResponse.cookies, client);

    final tempSession = CredentialsSession(
      username: actualUsername,
      password: password,
      cookies: loginResponse.cookies,
      faculties: [tempFaculty],
    );

    final faculties = await getStudentFaculties(tempSession, client);

    final session = CredentialsSession(
      username: tempSession.username,
      cookies: tempSession.cookies,
      faculties: faculties,
      password: password,
    );

    return session;
  }

  Future<LoginSuccessfulResponse> _loginOrFail(
    String username,
    String password,
    http.Client httpClient,
  ) async {
    final html = SigarraHtml();

    final loginResponse =
        await html.authentication
            .login(
              username: username,
              password: password,
              options: FacultyRequestOptions(
                faculty: tempFaculty,
                client: httpClient,
              ),
            )
            .call();

    if (!loginResponse.success) {
      _handleLoginFailure(loginResponse.asFailed());
    }

    return loginResponse.asSuccessful();
  }

  /*return CredentialsSession(
      username: '',
      password: password,
      cookies: info.cookies,
      faculties: [tempFaculty],
    );*/

  Never _handleLoginFailure(LoginFailedResponse response) {
    final failureReason = response.reason;

    // FIXME(limwa): convey the reason to the user
    if (failureReason == LoginFailureReason.expiredCredentials) {
      throw const AuthenticationException(
        'Failed to authenticate user',
        AuthenticationExceptionType.expiredCredentials,
      );
    } else if (failureReason == LoginFailureReason.internetError) {
      throw const AuthenticationException(
        'Failed to authenticate user',
        AuthenticationExceptionType.internetError,
      );
    } else if (failureReason == LoginFailureReason.wrongCredentials) {
      throw const AuthenticationException(
        'Failed to authenticate user',
        AuthenticationExceptionType.wrongCredentials,
      );
    } else {
      throw genericAuthenticationException;
    }
  }

  Future<String> _getUsername(List<Cookie> cookies, http.Client client) async {
    final authenticatedClient = CookieClient(client, cookies: () => cookies);

    final html = SigarraHtml();
    final request = html.home(
      options: FacultyRequestOptions(
        // FEUP has the photo on the home page
        faculty: tempFaculty,
        client: authenticatedClient,
      ),
    );

    final response = await request.call();

    if (!response.success) {
      throw genericAuthenticationException;
    }

    final successfulResponse = response.asSuccessful();
    if (!successfulResponse.authenticated) {
      throw genericAuthenticationException;
    }

    final authenticatedResponse = successfulResponse.asAuthenticated();
    final photoUrl = authenticatedResponse.photoUrl;

    final username = photoUrl?.queryParameters['pct_cod'];
    if (username == null || username.isEmpty) {
      throw genericAuthenticationException;
    }

    return username;
  }
}

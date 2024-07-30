import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_session.dart';
import 'package:uni/controller/session/credentials/session.dart';
import 'package:uni/controller/session/request.dart';
import 'package:uni/model/entities/login_exceptions.dart';

part '../../../generated/controller/session/credentials/request.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialsSessionRequest extends SessionRequest {
  CredentialsSessionRequest({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  Future<CredentialsSession> perform() async {
    // We need to login to fetch the faculties, so perform a temporary login.

    final tempSession = await NetworkRouter.login(
      username,
      password,
      ['feup'],
      persistentSession: false,
      ignoreCached: true,
    );

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

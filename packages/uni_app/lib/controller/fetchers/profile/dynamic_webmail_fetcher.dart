import 'package:uni/controller/fetchers/core/session_dependent_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_sigarra_webmail.dart';
import 'package:uni/model/entities/dynamic_webmail.dart';
import 'package:uni/session/flows/base/session.dart';

class MailAttachmentsFetcher implements SessionDependentFetcher {
  @override
  List<String> getEndpoints(Session session) {
    return NetworkRouter.getBaseUrlsFromSession(
      session,
    ).map((url) => '${url}mail_dinamico.ficheiros').toList();
  }

  /// Returns the [MailAttachment]'s information.
  static Future<List<MailAttachment>?> fetchMailAttachments(
    Session session,
  ) async {
    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'mail_dinamico.ficheiros';

    final response = await NetworkRouter.getWithCookies(url, {}, session);

    if (response.statusCode != 200) {
      return null;
    }

    return parseMailAttachments(response);
  }
}

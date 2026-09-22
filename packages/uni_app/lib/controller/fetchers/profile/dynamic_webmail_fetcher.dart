import 'package:flutter/foundation.dart';
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

  static Future<List<MailAttachment>> fetchMailAttachments(
    Session session,
  ) async {
    final baseUrls = NetworkRouter.getBaseUrlsFromSession(session);
    final attachments = <MailAttachment>[];

    for (final baseUrl in baseUrls) {
      final url = '${baseUrl}mail_dinamico.ficheiros';

      try {
        final response = await NetworkRouter.getWithCookies(url, {}, session);

        if (response.statusCode != 200) {
          debugPrint(
            'MailAttachmentsFetcher: HTTP ${response.statusCode} em $url',
          );
          continue;
        }

        attachments.addAll(parseMailAttachments(response, baseUrl: baseUrl));
      } catch (e) {
        debugPrint('MailAttachmentsFetcher: erro ao obter $url — $e');
      }
    }

    attachments.sort((a, b) => b.date.compareTo(a.date));

    return attachments;
  }
}

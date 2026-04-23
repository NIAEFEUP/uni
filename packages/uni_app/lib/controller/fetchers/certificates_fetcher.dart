import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_certificates.dart';
import 'package:uni/model/entities/certificate.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/session/flows/base/session.dart';

class CertificatesFetcher implements SessionDependantFetcher {
  static const certificatesPath = 'CERT_GERAL.PED_CERT_LIST';

  @override
  List<String> getEndpoints(Session session) {
    final localizedBaseUrls = NetworkRouter.getBaseUrlsFromSession(
      session,
      languageSensitive: true,
    );
    final fallbackBaseUrls = NetworkRouter.getBaseUrlsFromSession(session);

    final baseUrls = [...localizedBaseUrls];
    for (final url in fallbackBaseUrls) {
      if (!baseUrls.contains(url)) {
        baseUrls.add(url);
      }
    }

    return baseUrls
        .map((url) => '$url$certificatesPath')
        .toList();
  }

  Map<String, String> _buildQuery(Course course) {
    return {
      if (course.festId != null) 'pv_fest_id': course.festId.toString(),
    };
  }

  Future<List<Certificate>> getUserCertificates(
    Session session,
    Course course,
  ) async {
    final query = _buildQuery(course);
    final endpoints = getEndpoints(session);
    List<Certificate>? firstValidPageResult;

    for (final endpoint in endpoints) {
      final response =
          await NetworkRouter.getWithCookies(endpoint, query, session);
      if (response.statusCode != 200) {
        continue;
      }

      final pageLooksLikeCertificates = isCertificatesPage(response);
      if (!pageLooksLikeCertificates) {
        continue;
      }

      final certificates = parseCertificates(response, baseUrl: endpoint);
      if (certificates.isNotEmpty) {
        return certificates;
      }

      firstValidPageResult ??= certificates;
    }

    return firstValidPageResult ?? [];
  }
}

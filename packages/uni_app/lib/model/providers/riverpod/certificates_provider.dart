import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/certificates_fetcher.dart';
import 'package:uni/model/entities/certificate.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final certificatesProvider = FutureProvider.family<List<Certificate>, Course>(
  (ref, course) async {
    final session = await ref.watch(sessionProvider.future);
    if (session == null) {
      return [];
    }

    return CertificatesFetcher().getUserCertificates(session, course);
  },
);

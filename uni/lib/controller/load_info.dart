import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_providers.dart';

Future<void> handleRefresh(StateProviders stateProviders) async {
  Logger().e('TODO: handleRefresh');
}

Future<File?> loadProfilePicture(Session session, {forceRetrieval = false}) {
  final String studentNumber = session.studentNumber;
  final String faculty = session.faculties[0];
  final String url =
      'https://sigarra.up.pt/$faculty/pt/fotografias_service.foto?pct_cod=$studentNumber';
  final Map<String, String> headers = <String, String>{};
  headers['cookie'] = session.cookies;
  return loadFileFromStorageOrRetrieveNew('user_profile_picture', url, headers,
      forceRetrieval: forceRetrieval);
}

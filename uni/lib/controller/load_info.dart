import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_providers.dart';

/*Future loadReloginInfo(StateProviders stateProviders) async {
  final Tuple2<String, String> userPersistentCredentials =
      await AppSharedPreferences.getPersistentUserInfo();
  final String userName = userPersistentCredentials.item1;
  final String password = userPersistentCredentials.item2;
  final List<String> faculties = await AppSharedPreferences.getUserFaculties();

  if (userName != '' && password != '') {
    final action = Completer();
    stateProviders.sessionProvider
        .reLogin(userName, password, faculties, stateProviders, action: action);
    return action.future;
  }
  return Future.error('No credentials stored');
}*/

Future loadUserProfileInfoFromRemote(StateProviders stateProviders) async {
  /*if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    return;
  }

  Logger().i('Loading remote info');

  final session = stateProviders.sessionProvider.session;
  if (!session.authenticated && session.persistentSession) {
    await loadReloginInfo(stateProviders);
  }*/

  stateProviders.profileStateProvider
      .fetchUserInfo(Completer(), stateProviders.sessionProvider.session);

  stateProviders.lastUserInfoProvider
      .setLastUserInfoUpdateTimestamp(Completer());
}

Future<void> handleRefresh(StateProviders stateProviders) async {
  Logger().e('TODO: handleRefresh');
  // await loadRemoteUserInfoToState(stateProviders);
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

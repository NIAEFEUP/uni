import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/profile_info_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/profile_info.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/pedagogical_surveys_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

final profileProvider =
    AsyncNotifierProvider<ProfileInfoNotifier, ProfileInfo?>(
      ProfileInfoNotifier.new,
    );

class ProfileInfoNotifier extends CachedAsyncNotifier<ProfileInfo?> {
  @override
  Duration? get cacheDuration => const Duration(days: 1);

  @override
  Future<ProfileInfo?> loadFromStorage() async {
    final profileInfo = Database().profileInfo;

    return profileInfo;
  }

  @override
  Future<ProfileInfo?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return null;
    }

    // try to fetch all data from internet
    final profileInfo = await _fetchUserInfo(session);
    if (profileInfo == null) {
      return null;
    }

    ref.read(pedagogicalSurveysProvider.notifier).state =
        PreferencesController.shouldShowPedagogicalSurveysDialog();

    // if successful save everything to cache
    Database().saveProfileInfo(profileInfo);

    return profileInfo;
  }

  Future<ProfileInfo?> _fetchUserInfo(Session session) async {
    final profileInfo = await ProfileInfoFetcher.fetchProfileInfo(session);
    if (profileInfo == null) {
      return null;
    }

    return profileInfo;
  }
}

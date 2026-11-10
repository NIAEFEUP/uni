import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/profile/profile_info_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/profile_info.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

final profileInfoProvider =
    AsyncNotifierProvider<ProfileInfoNotifier, ProfileInfo?>(
      ProfileInfoNotifier.new,
    );

class ProfileInfoNotifier extends CachedAsyncNotifier<ProfileInfo?> {
  @override
  Duration? get cacheDuration => const Duration(days: 30);

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

    // if successful save everything to cache
    await Database().saveProfileInfo(profileInfo);

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

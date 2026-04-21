import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/library_occupation_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final libraryProvider =
    AsyncNotifierProvider<LibraryOccupationNotifier, LibraryOccupation?>(
      LibraryOccupationNotifier.new,
    );

final class LibraryOccupationNotifier
    extends CachedAsyncNotifier<LibraryOccupation?> {
  @override
  Duration? get cacheDuration => const Duration(hours: 1);

  @override
  Future<LibraryOccupation> loadFromStorage() async {
    final occupation = LibraryOccupation(0, 0);

    Database().libraryOccupations.forEach(occupation.addFloor);

    return occupation;
  }

  @override
  Future<LibraryOccupation> loadFromRemote() async {
    //try to fetch from internet
    final occupation = await LibraryOccupationFetcher().getLibraryOccupation();

    //if success save to database
    Database().saveLibraryOccupations(occupation.floors);

    return occupation;
  }
}

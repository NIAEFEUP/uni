import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/parking_lot_fetcher.dart';
import 'package:uni/model/entities/parking_lot_occupation.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final parkingLotProvider =
    AsyncNotifierProvider<ParkingLotNotifier, ParkingLotOccupation?>(
      ParkingLotNotifier.new,
    );

final class ParkingLotNotifier
    extends CachedAsyncNotifier<ParkingLotOccupation?> {
  @override
  Duration? get cacheDuration => const Duration(minutes: 15);

  @override
  Future<ParkingLotOccupation?> loadFromStorage() async {
    return null;
  }

  @override
  Future<ParkingLotOccupation?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return null;
    }

    return ParkingLotFetcher().getParkingLotOccupation(session);
  }
}

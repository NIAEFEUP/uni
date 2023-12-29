import 'dart:async';

import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_library_reservation.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class LibraryReservationsProvider
    extends StateProviderNotifier<List<LibraryReservation>> {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  List<LibraryReservation>? _reservations;

  List<LibraryReservation> get reservations => _reservations ?? [];

  @override
  Future<List<LibraryReservation>> loadFromStorage(
    StateProviders stateProviders,
  ) {
    final db = LibraryReservationDatabase();
    return db.reservations();
  }

  @override
  Future<List<LibraryReservation>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    final session = stateProviders.sessionProvider.state!;
    final reservations =
        await LibraryReservationsFetcherHtml().getReservations(session);

    final db = LibraryReservationDatabase();
    unawaited(db.saveReservations(reservations));

    return reservations;
  }
}

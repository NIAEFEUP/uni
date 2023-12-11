import 'dart:async';

import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/app_library_reservation.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LibraryReservationsProvider extends StateProviderNotifier {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  List<LibraryReservation>? _reservations;

  List<LibraryReservation> get reservations => _reservations ?? [];

  @override
  Future<void> loadFromStorage() async {
    final db = LibraryReservationDatabase();
    final reservations = await db.reservations();

    _reservations = reservations;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchLibraryReservations(session);
  }

  Future<void> fetchLibraryReservations(
    Session session,
  ) async {
    _reservations =
        await LibraryReservationsFetcherHtml().getReservations(session);

    final db = LibraryReservationDatabase();
    unawaited(db.saveReservations(reservations));
  }
}

import 'dart:async';

import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/app_library_reservation.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class LibraryReservationsProvider extends StateProviderNotifier {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  List<LibraryReservation>? _reservations;

  List<LibraryReservation> get reservations => _reservations ?? [];

  @override
  Future<void> loadFromStorage() async {
    final LibraryReservationDatabase db = LibraryReservationDatabase();
    final List<LibraryReservation> reservations = await db.reservations();

    _reservations = reservations;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchLibraryReservations(session);
  }

  Future<void> fetchLibraryReservations(
    Session session,
  ) async {
    try {
      _reservations =
          await LibraryReservationsFetcherHtml().getReservations(session);

      final LibraryReservationDatabase db = LibraryReservationDatabase();
      db.saveReservations(reservations);

      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }
}

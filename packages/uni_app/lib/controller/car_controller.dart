import 'dart:io';
import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/parking_lot_occupation.dart';
import 'package:uni/model/providers/riverpod/parking_lot_provider.dart';

class CarController {
  CarController(this.ref);

  final Ref ref;
  bool _initialized = false;

  void init() {
    if (_initialized) {
      return;
    }
    _initialized = true;

    ref.listen(parkingLotProvider, (previous, next) {
      next.whenData((occupation) {
        if (occupation != null) {
          _updateCarTemplates(occupation);
        }
      });
    }, fireImmediately: true);
  }

  void _updateCarTemplates(ParkingLotOccupation occupation) {
    S s;
    try {
      s = S.current;
    } catch (_) {
      return;
    }

    if (Platform.isIOS) {
      final cpItems = occupation.lots.map((lot) {
        final name = _lotName(lot.type, s);
        final free = lot.free;
        final capacity = lot.capacity;
        return CPListItem(
          text: name,
          detailText: '$free / $capacity ${s.parking_lot_free}',
          onPress: (complete, self) => complete(),
        );
      }).toList();

      FlutterCarplay.setRootTemplate(
        rootTemplate: CPListTemplate(
          sections: [CPListSection(items: cpItems, header: s.parking_lots)],
          title: 'uni',
          systemIcon: 'car',
        ),
      );
    }

    if (Platform.isAndroid) {
      final aaItems = occupation.lots.map((lot) {
        final name = _lotName(lot.type, s);
        final free = lot.free;
        final capacity = lot.capacity;
        return AAListItem(
          title: name,
          subtitle: '$free / $capacity ${s.parking_lot_free}',
          onPress: (complete, item) => complete(),
        );
      }).toList();

      FlutterAndroidAuto.setRootTemplate(
        template: AAListTemplate(
          sections: [AAListSection(items: aaItems, title: s.parking_lots)],
          title: 'uni',
        ),
      );
    }
  }

  String _lotName(ParkingLotType type, S s) {
    switch (type) {
      case ParkingLotType.permanentStaff:
        return s.parking_lot_permanent_staff;
      case ParkingLotType.students:
        return s.parking_lot_students;
      case ParkingLotType.nonPermanentStaff:
        return s.parking_lot_non_permanent_staff;
    }
  }
}

final carControllerProvider = Provider(CarController.new);

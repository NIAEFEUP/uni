import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/parking_lot_occupation.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/parking_lot_provider.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/parking/parking_card_shimmer.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/parking_lot_card.dart';
import 'package:uni_ui/icons.dart';

String _lotName(BuildContext context, ParkingLotType type) {
  final s = S.of(context);
  return switch (type) {
    ParkingLotType.permanentStaff => s.parking_lot_permanent_staff,
    ParkingLotType.students => s.parking_lot_students,
    ParkingLotType.nonPermanentStaff => s.parking_lot_non_permanent_staff,
  };
}

class ParkingLotHomeCard extends GenericHomecard {
  const ParkingLotHomeCard({super.key})
    : super(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
      );

  @override
  String getTitle(BuildContext context) {
    return S.of(context).parking_lots;
  }

  @override
  void onCardClick(BuildContext context) => {};

  @override
  Widget buildCardContent(BuildContext context) {
    return DefaultConsumer<ParkingLotOccupation>(
      provider: parkingLotProvider,
      builder: (context, ref, occupation) => ParkingLotCard(
        lots: occupation.lots
            .map(
              (lot) => ParkingLotRowWidget(
                lotId: lot.id,
                lotName: _lotName(context, lot.type),
                free: lot.free,
                capacity: lot.capacity,
                freeLabel: S.of(context).parking_lot_free,
              ),
            )
            .toList(),
      ),
      hasContent: (occupation) => occupation.lots.isNotEmpty,
      nullContentWidget: Center(
        child: IconLabel(
          icon: Icon(UniIcons.parking, size: 45),
          label: S.of(context).no_parking_info,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      loadingWidget: const ShimmerParkingHomeCard(),
    );
  }
}

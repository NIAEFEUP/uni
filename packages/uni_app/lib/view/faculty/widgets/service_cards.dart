import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/faculty/widgets/generic_service_card.dart';

class AllServiceCards extends StatelessWidget {
  const AllServiceCards({super.key});


  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        serviceCardsInRows(
            ServicesCard(name: S.of(context).copy_center,
                openingHours: const ['9:00h - 11:30h', '12:30h - 18:00h',],
            ),
            ServicesCard(name: S.of(context).dona_bia,
                openingHours: const ['8:30h - 12:00h', '13:30h - 19:00h',],
            ),
        ),
        serviceCardsInRows(
          const ServicesCard(name: 'Infodesk',
            openingHours: ['9:30h - 13:00h',  '14:00h - 17:30h',],
          ),
          ServicesCard(name: S.of(context).academic_services,
            openingHours: const ['11:00h - 16:00h',],
          ),
        ),
      ],
    );
  }

  Widget serviceCardsInRows(Widget card1, Widget card2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: card1,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: card2,
          ),
        ],
      ),
    );
  }
}
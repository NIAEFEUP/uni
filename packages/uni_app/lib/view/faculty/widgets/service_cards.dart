import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/faculty/widgets/generic_service_card.dart';

class AllServiceCards extends StatelessWidget {
  const AllServiceCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1.5,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ServicesCard(
            name: S.of(context).copy_center,
            openingHours: const [
              '9:00h - 11:30h',
              '12:30h - 18:00h',
            ],
          ),
          ServicesCard(
            name: S.of(context).dona_bia,
            openingHours: const [
              '8:30h - 12:00h',
              '13:30h - 19:00h',
            ],
          ),
          const ServicesCard(
            name: 'Infodesk',
            openingHours: [
              '9:30h - 13:00h',
              '14:00h - 17:30h',
            ],
          ),
          ServicesCard(
            name: S.of(context).academic_services,
            openingHours: const [
              '11:00h - 16:00h',
            ],
          ),
          ServicesCard(
            name: S.of(context).multimedia_center,
            openingHours: const [
              '9:00h - 12:30h',
              '14:30h - 17:00h',
            ],
          ),
          const ServicesCard(
            name: 'Links',
            openingHours: [],
          ),
        ],
      ),
    );
  }
}

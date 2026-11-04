import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/faculty/widgets/generic_service_card.dart';
import 'package:uni_ui/icons.dart';

class AllServiceCards extends StatefulWidget {
  const AllServiceCards({super.key});

  @override
  State<AllServiceCards> createState() => AllServiceCardsState();
}

class AllServiceCardsState extends State<AllServiceCards> {
  late bool isGrid;

  @override
  void initState() {
    super.initState();
    isGrid = PreferencesController.getServiceCardsIsGrid();
  }

  void setGrid({required bool value}) {
    setState(() {
      PreferencesController.setServiceCardsIsGrid(value);
      isGrid = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = <Widget>[
      ServicesCard(
        name: S.of(context).library,
        openingHours: const ['8:30h - 19:30h'],
        location: S.of(context).library_building,
        telephone: '+351 225 081 442',
        email: 'biblioteca@fe.up.pt',
      ),
      ServicesCard(
        name: S.of(context).goi,
        openingHours: const ['9:30h - 15:30h'],
        location: 'A210, A211a, A211b, A212, A276',
        telephone: '+351 220 413 578',
        email: 'spo@fe.up.pt',
      ),
      ServicesCard(
        name: 'FEUP ${S.of(context).copy_center}',
        openingHours: const ['9:00h - 11:30h', '12:30h - 18:00h'],
        location: S.of(context).copy_center_building.split(' | ')[0],
        telephone: '+351 220 994 122',
      ),
      ServicesCard(
        name: 'AEFEUP ${S.of(context).copy_center}',
        openingHours: const ['9:00h - 11:30h', '12:30h - 18:00h'],
        location: S.of(context).copy_center_building.split(' | ')[1],
        telephone: '+351 220 994 132',
        email: 'editorial@aefeup.pt',
      ),
      ServicesCard(
        name: S.of(context).dona_bia,
        openingHours: const ['9:00h - 12:00h', '14:00h - 18:00h'],
        location: S.of(context).dona_bia_building,
        telephone: '+351 225 081 416',
        email: 'papelaria.fe.up@gmail.com',
      ),
      const ServicesCard(
        name: 'Infodesk',
        openingHours: ['9:30h - 13:00h', '14:00h - 17:30h'],
        location: 'FEUP Entrance',
        telephone: '+351 225 081 400',
        email: 'infodesk@fe.up.pt',
      ),
      ServicesCard(
        name: S.of(context).multimedia_center,
        openingHours: const ['9:00h - 12:30h', '14:30h - 17:00h'],
        location: '${S.of(context).room} B123',
        telephone: '+351 225 081 466',
        email: 'imprimir@fe.up.pt',
      ),
      ServicesCard(
        name: S.of(context).academic_services,
        openingHours: const ['11:00h - 16:00h'],
        telephone: '+351 225 081 977',
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Text(
              S.of(context).services,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => setGrid(value: false),
              icon: UniIcon(
                UniIcons.list,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            IconButton(
              onPressed: () => setGrid(value: true),
              icon: UniIcon(
                UniIcons.grid,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isGrid
                ? (constraints.maxWidth - 8) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final service in services)
                  SizedBox(width: cardWidth, child: service),
              ],
            );
          },
        ),
      ],
    );
  }
}

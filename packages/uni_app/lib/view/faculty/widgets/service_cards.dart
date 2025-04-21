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

  void changeCardsToGrid() {
    setState(() {
      PreferencesController.setServiceCardsIsGrid(true);
      isGrid = true;
    });
  }

  void changeCardsToList() {
    setState(() {
      PreferencesController.setServiceCardsIsGrid(false);
      isGrid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = <Widget>[
      ServicesCard(
        name: 'FEUP ${S.of(context).copy_center}',
        openingHours: const [
          '9:00h - 11:30h',
          '12:30h - 18:00h',
        ],
        location: S.of(context).copy_center_building.split(' | ')[0],
        telephone: '+351 220 994 122',
      ),
      ServicesCard(
        name: 'AEFEUP ${S.of(context).copy_center}',
        openingHours: const [
          '9:00h - 11:30h',
          '12:30h - 18:00h',
        ],
        location: S.of(context).copy_center_building.split(' | ')[1],
        telephone: '+351 220 994 132',
        email: 'editorial@aefeup.pt',
      ),
      ServicesCard(
        name: S.of(context).dona_bia,
        openingHours: const [
          '8:30h - 12:00h',
          '13:30h - 19:00h',
        ],
        location: S.of(context).dona_bia_building,
        telephone: '+351 225 081 416',
        email: 'papelaria.fe.up@gmail.com',
      ),
      const ServicesCard(
        name: 'Infodesk',
        openingHours: [
          '9:30h - 13:00h',
          '14:00h - 17:30h',
        ],
        location: 'FEUP Entrance',
        telephone: '+351 225 081 400',
        email: 'infodesk@fe.up.pt',
      ),
      ServicesCard(
        name: S.of(context).multimedia_center,
        openingHours: const [
          '9:00h - 12:30h',
          '14:30h - 17:00h',
        ],
        location: '${S.of(context).room} B123',
        telephone: '+351 225 081 466',
        email: 'imprimir@fe.up.pt',
      ),
      ServicesCard(
        name: S.of(context).academic_services,
        openingHours: const [
          '11:00h - 16:00h',
        ],
        telephone: '+351 225 081 977',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                'Services',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: changeCardsToList,
                icon: const UniIcon(UniIcons.list),
              ),
              IconButton(
                onPressed: changeCardsToGrid,
                icon: const UniIcon(UniIcons.grid),
              ),
            ],
          ),
          const SizedBox(height: 7),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isGrid) {
                const spacing = 7.0;
                final itemWidth = (constraints.maxWidth - spacing * 2) / 2;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: services
                      .map(
                        (service) => SizedBox(
                          width: itemWidth,
                          child: service,
                        ),
                      )
                      .toList(),
                );
              } else {
                return Column(
                  children: services
                      .map(
                        (service) => Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 7,
                            end: 7,
                            bottom: 7,
                          ),
                          child: service,
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

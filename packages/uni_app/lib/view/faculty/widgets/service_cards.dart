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

  void changeCardsToGrid(){
    setState(() {
      PreferencesController.setServiceCardsIsGrid(true);
      isGrid = true;
    });
  }

  void changeCardsToList(){
    setState(() {
      PreferencesController.setServiceCardsIsGrid(false);
      isGrid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          margin: const EdgeInsets.all(7),
          child: GridView.count(
            crossAxisCount: isGrid ? 2 : 1,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: isGrid ? 1.97 : 4,
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
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uni_ui/cards/service_card.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni/generated/l10n.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.name,
    required this.openingHours,
    required this.location,
    required this.telephone,
    required this.email,
  });

  final String name;
  final List<String> openingHours;
  final String telephone;
  final String email;
  final String location;

  void onClick(BuildContext context) {
    Popup(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(context);
      },
      child: ServiceCard(
        name: name,
        openingHours: openingHours,
        tooltip: "",
      ),
    );
  }

  Future<void> Popup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModalDialog(
            children: [
              ModalServiceInfo(name: name, durations: openingHours),
              ModalInfoRow(title: "Location", description: location, icon: UniIcon(UniIcons.location)),
              ModalInfoRow(title: S.of(context).telephone, description: telephone, icon: UniIcon(UniIcons.phone)),
              ModalInfoRow(title: "Email", description: email, icon: UniIcon(UniIcons.email)),
            ],
          );
        },
    );
  }
}

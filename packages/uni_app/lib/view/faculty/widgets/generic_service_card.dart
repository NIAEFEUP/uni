import 'package:flutter/material.dart';
import 'package:uni_ui/cards/service_card.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/icons.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.name,
    required this.openingHours,
  });

  final String name;
  final List<String> openingHours;

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
              ModalInfoRow(title: "Location", description: "", icon: UniIcon(UniIcons.location)),
              ModalInfoRow(title: "Phone Number", description: "", icon: UniIcon(UniIcons.phone)),
              ModalInfoRow(title: "Email", description: "", icon: UniIcon(UniIcons.email)),
            ],
          );
        },
    );
  }
}

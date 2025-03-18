import 'package:flutter/material.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/service_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.name,
    required this.openingHours,
    this.location = '',
    this.telephone = '',
    this.email = '',
  });

  final String name;
  final List<String> openingHours;
  final String telephone;
  final String email;
  final String location;

  void onClick(BuildContext context) {
    popUp(context);
  }

  @override
  Widget build(BuildContext context) {
    return ServiceCard(
      name: name,
      openingHours: openingHours,
      tooltip: '',
      function: onClick,
    );
  }

  Future<void> popUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalDialog(
          children: [
            ModalServiceInfo(name: name, durations: openingHours),
            if (location != '')
              ModalInfoRow(
                title: 'Location',
                description: location,
                icon: UniIcon(
                  UniIcons.location,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            if (telephone != '')
              GestureDetector(
                onTap: () => launchUrlWithToast(
                  context,
                  'tel:${telephone.substring(5)}',
                ),
                child: ModalInfoRow(
                  title: S.of(context).telephone,
                  description: telephone,
                  icon: UniIcon(
                    UniIcons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  optionalIcon: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            if (email != '')
              GestureDetector(
                onTap: () => launchUrlWithToast(context, 'mailto:$email'),
                child: ModalInfoRow(
                  title: 'Email',
                  description: email,
                  icon: UniIcon(
                    UniIcons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  optionalIcon: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

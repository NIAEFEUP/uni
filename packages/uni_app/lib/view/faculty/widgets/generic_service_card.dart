import 'package:flutter/widgets.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/service_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';
import 'package:uni_ui/theme.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.name,
    required this.openingHours,
    this.location,
    this.telephone,
    this.email,
  });

  final String name;
  final List<String> openingHours;
  final String? telephone;
  final String? email;
  final String? location;

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
            if (location != null)
              ModalInfoRow(
                title: S.of(context).location,
                description: location,
                icon: UniIcons.location,
              ),
            if (telephone != null)
              GestureDetector(
                onTap:
                    () => launchUrlWithToast(
                      context,
                      'tel:${telephone?.substring(5)}',
                    ),
                child: ModalInfoRow(
                  title: S.of(context).telephone,
                  description: telephone,
                  icon: UniIcons.phone,
                  trailing: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).primaryVibrant,
                  ),
                ),
              ),
            if (email != null)
              GestureDetector(
                onTap: () => launchUrlWithToast(context, 'mailto:$email'),
                child: ModalInfoRow(
                  title: S.of(context).email,
                  description: email,
                  icon: UniIcons.email,
                  trailing: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).primaryVibrant,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

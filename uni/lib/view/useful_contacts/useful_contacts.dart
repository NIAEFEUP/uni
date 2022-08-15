import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/useful_contacts/widgets/academic_services_card.dart';
import 'package:uni/view/useful_contacts/widgets/copy_center_card.dart';
import 'package:uni/view/useful_contacts/widgets/dona_bia_card.dart';
import 'package:uni/view/useful_contacts/widgets/info_desk_card.dart';
import 'package:uni/view/useful_contacts/widgets/multimedia_center_card.dart';

class UsefulContactsCardView extends StatefulWidget {
  const UsefulContactsCardView({super.key});

  @override
  State<StatefulWidget> createState() => UsefulContactsCardViewState();
}

/// Manages the 'Useful Contacts' section of the app.
class UsefulContactsCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ListView(children: childrenList());
  }

  List<Widget> childrenList() {
    final List<Widget> list = [];
    list.add(AcademicServicesCard());
    list.add(InfoDeskCard());
    list.add(DonaBiaCard());
    list.add(CopyCenterCard());
    list.add(MulimediaCenterCard());
    return list;
  }
}

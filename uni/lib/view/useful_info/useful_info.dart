import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/useful_info/widgets/academic_services_card.dart';
import 'package:uni/view/useful_info/widgets/copy_center_card.dart';
import 'package:uni/view/useful_info/widgets/dona_bia_card.dart';
import 'package:uni/view/useful_info/widgets/infodesk_card.dart';
import 'package:uni/view/useful_info/widgets/multimedia_center_card.dart';
import 'package:uni/view/useful_info/widgets/other_links_card.dart';
import 'package:uni/view/useful_info/widgets/sigarra_links_card.dart';
import 'package:uni/view/common_widgets/page_title.dart';

class UsefulInfoCardView extends StatefulWidget {
  const UsefulInfoCardView({super.key});

  @override
  State<StatefulWidget> createState() => UsefulInfoCardViewState();
}

/// Manages the 'Useful Info' section of the app.
class UsefulInfoCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ListView(children: childrenList());
  }

  Container getPageTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: const PageTitle(name: 'Informações Úteis'));
  }

  List<Widget> childrenList() {
    final List<Widget> list = [];
    list.add(getPageTitle());
    list.add(const AcademicServicesCard());
    list.add(const InfoDeskCard());
    list.add(const DonaBiaCard());
    list.add(const CopyCenterCard());
    list.add(const MulimediaCenterCard());
    list.add(const SigarraLinksCard());
    list.add(const OtherLinksCard());
    return list;
  }
}

import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/useful_info/widgets/academic_services_card.dart';
import 'package:uni/view/useful_info/widgets/copy_center_card.dart';
import 'package:uni/view/useful_info/widgets/dona_bia_card.dart';
import 'package:uni/view/useful_info/widgets/infodesk_card.dart';
import 'package:uni/view/useful_info/widgets/multimedia_center_card.dart';
import 'package:uni/view/useful_info/widgets/other_links_card.dart';
import 'package:uni/view/useful_info/widgets/sigarra_links_card.dart';

class UsefulInfoPageView extends StatefulWidget {
  const UsefulInfoPageView({super.key});

  @override
  State<StatefulWidget> createState() => UsefulInfoPageViewState();
}

/// Manages the 'Useful Info' section of the app.
class UsefulInfoPageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ListView(children: [
      _getPageTitle(),
      const AcademicServicesCard(),
      const InfoDeskCard(),
      const DonaBiaCard(),
      const CopyCenterCard(),
      const MultimediaCenterCard(),
      const SigarraLinksCard(),
      const OtherLinksCard()
    ]);
  }

  Container _getPageTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: const PageTitle(name: 'Úteis'));
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}
}

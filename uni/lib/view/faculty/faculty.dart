import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/calendar_card.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/faculty/widgets/academic_services_card.dart';
import 'package:uni/view/faculty/widgets/copy_center_card.dart';
import 'package:uni/view/faculty/widgets/dona_bia_card.dart';
import 'package:uni/view/faculty/widgets/infodesk_card.dart';
import 'package:uni/view/faculty/widgets/multimedia_center_card.dart';
import 'package:uni/view/faculty/widgets/other_links_card.dart';
import 'package:uni/view/faculty/widgets/sigarra_links_card.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class FacultyPageView extends StatefulWidget {
  const FacultyPageView({super.key});

  @override
  State<StatefulWidget> createState() => FacultyPageViewState();
}

class FacultyPageViewState extends GeneralPageViewState {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navFaculty.route);

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        LibraryOccupationCard(),
        CalendarCard(),
        ...getUtilsSection(),
      ],
    );
  }

  List<GenericExpansionCard> getUtilsSection() {
    return const [
      AcademicServicesCard(),
      InfoDeskCard(),
      DonaBiaCard(),
      CopyCenterCard(),
      MultimediaCenterCard(),
      SigarraLinksCard(),
      OtherLinksCard(),
    ];
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

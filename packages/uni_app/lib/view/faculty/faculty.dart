import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/faculty/widgets/service_cards.dart';
import 'package:uni/view/home/widgets/calendar/calendar_home_card.dart';
import 'package:uni/view/home/widgets/library/library_home_card.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';

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
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: LibraryHomeCard(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: CalendarHomeCard(),
        ),
        AllServiceCards(),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

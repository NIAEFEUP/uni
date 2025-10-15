import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/library_occupation_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/faculty/widgets/service_cards.dart';
import 'package:uni/view/home/widgets/calendar/calendar_home_card.dart';
import 'package:uni/view/home/widgets/library/library_home_card.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';

class FacultyPageView extends ConsumerStatefulWidget {
  const FacultyPageView({super.key});

  @override
  ConsumerState<FacultyPageView> createState() => FacultyPageViewState();
}

class FacultyPageViewState extends GeneralPageViewState<FacultyPageView> {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navFaculty.route);

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 16, left: 20, right: 20),
          child: LibraryHomeCard(),
        ),
        Padding(padding: EdgeInsets.only(top: 16), child: CalendarHomeCard()),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: AllServiceCards(),
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh() async {
    await ref.read(libraryProvider.notifier).refreshRemote();
  }
}

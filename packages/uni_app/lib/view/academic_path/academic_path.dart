import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/academic_path/courses_page.dart';
import 'package:uni/view/academic_path/exam_page.dart';
import 'package:uni/view/academic_path/schedule_page.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';

class AcademicPathPageView extends StatefulWidget {
  const AcademicPathPageView({
    super.key,
    this.initialTabIndex = 0,
  });
  final int initialTabIndex;

  @override
  State<StatefulWidget> createState() => AcademicPathPageViewState();
}

class AcademicPathPageViewState
    extends GeneralPageViewState<AcademicPathPageView>
    with SingleTickerProviderStateMixin {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navAcademicPath.route);

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget? getHeader(BuildContext context) {
    return TabBar(
      controller: tabController,
      dividerHeight: 1,
      tabs: [
        TabIcon(icon: UniIcons.courses, text: S.of(context).courses),
        TabIcon(icon: UniIcons.lecture, text: S.of(context).lectures),
        TabIcon(icon: UniIcons.exam, text: S.of(context).exams),
      ],
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        const CoursesPage(),
        SchedulePage(),
        const ExamsPage(),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

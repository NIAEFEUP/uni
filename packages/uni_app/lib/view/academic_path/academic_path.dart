import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/academic_path/exam_page.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';
import 'package:uni/view/academic_path/widgets/course_units_card.dart';

class AcademicPathPageView extends StatefulWidget {
  const AcademicPathPageView({super.key});

  @override
  State<StatefulWidget> createState() => AcademicPathPageViewState();
}

class AcademicPathPageViewState extends GeneralPageViewState
    with SingleTickerProviderStateMixin {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navAcademicPath.route);

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
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
        TabIcon(
          icon: UniIcons.lecture,
          text: S.of(context).lectures,
        ),
        TabIcon(icon: UniIcons.exam, text: S.of(context).exams),
        TabIcon(icon: UniIcons.course, text: S.of(context).courses),
      ],
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Center(
          child: Text('To be implemented'),
        ),
        ExamsPage(),
        Center(
          child:  CourseUnitsCard(),
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    // TODO: implement onRefresh
  }
}

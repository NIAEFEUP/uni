import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/academic_path/exam_page.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

class AcademicPathPageView extends StatefulWidget {
  const AcademicPathPageView({super.key});

  @override
  State<StatefulWidget> createState() => AcademicPathPageViewState();
}

class AcademicPathPageViewState extends GeneralPageViewState {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navAcademicPath.route);

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).nav_title(NavigationItem.navAcademicPath.route),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Schedule'),
              Tab(text: 'Exams'),
              Tab(text: 'Courses'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(
              child: Text('To be implemented'),
            ),
            ExamsPage(),
            Center(
              child: Text('To be implemented'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    // TODO: implement onRefresh
  }
}

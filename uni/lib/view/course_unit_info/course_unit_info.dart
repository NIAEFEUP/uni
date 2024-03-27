import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';

class CourseUnitDetailPageView extends StatefulWidget {
  const CourseUnitDetailPageView(this.courseUnit, {super.key});

  final CourseUnit courseUnit;

  @override
  State<StatefulWidget> createState() {
    return CourseUnitDetailPageViewState();
  }
}

class CourseUnitDetailPageViewState
    extends SecondaryPageViewState<CourseUnitDetailPageView> {
  Future<void> loadInfo({required bool force}) async {
    final courseUnitsProvider =
        Provider.of<CourseUnitsInfoProvider>(context, listen: false);
    final session = context.read<SessionProvider>().state!;

    final courseUnitSheet =
        courseUnitsProvider.courseUnitsSheets[widget.courseUnit];
    if (courseUnitSheet == null || force) {
      await courseUnitsProvider.fetchCourseUnitSheet(
        widget.courseUnit,
        session,
      );
    }

    final courseUnitFiles =
        courseUnitsProvider.courseUnitsFiles[widget.courseUnit];
    if (courseUnitFiles == null || force) {
      await courseUnitsProvider.fetchCourseUnitFiles(
        widget.courseUnit,
        session,
      );
    }

    final courseUnitClasses =
        courseUnitsProvider.courseUnitsClasses[widget.courseUnit];
    if (courseUnitClasses == null || force) {
      await courseUnitsProvider.fetchCourseUnitClasses(
        widget.courseUnit,
        session,
      );
    }
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    await loadInfo(force: true);
  }

  @override
  Future<void> onLoad(BuildContext context) async {
    await loadInfo(force: false);
  }

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(
            center: false,
            name: widget.courseUnit.name,
          ),
          TabBar(
            tabs: [
              Tab(text: S.of(context).course_info),
              Tab(text: S.of(context).course_class),
              Tab(
                text: S.of(context).files,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TabBarView(
                children: [
                  _courseUnitSheetView(context),
                  _courseUnitClassesView(context),
                  _courseUnitFilesView(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    final sheet = context
        .read<CourseUnitsInfoProvider>()
        .courseUnitsSheets[widget.courseUnit];

    if (sheet == null || sheet.sections.isEmpty) {
      return Center(
        child: Text(
          S.of(context).no_info,
          textAlign: TextAlign.center,
        ),
      );
    }

    return CourseUnitSheetView(sheet);
  }

  Widget _courseUnitFilesView(BuildContext context) {
    final files = context
        .watch<CourseUnitsInfoProvider>()
        .courseUnitsFiles[widget.courseUnit];

    if (files == null || files.isEmpty) {
      return Center(
        child: Text(
          S.of(context).no_files_found,
          textAlign: TextAlign.center,
        ),
      );
    }

    return CourseUnitFilesView(files);
  }

  Widget _courseUnitClassesView(BuildContext context) {
    final classes = context
        .read<CourseUnitsInfoProvider>()
        .courseUnitsClasses[widget.courseUnit];

    if (classes == null || classes.isEmpty) {
      return Center(
        child: Text(
          S.of(context).no_class,
          textAlign: TextAlign.center,
        ),
      );
    }

    return CourseUnitClassesView(classes);
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navCourseUnits.route);
}

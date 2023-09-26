import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';
import 'package:uni/view/lazy_consumer.dart';

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
    final session = context.read<SessionProvider>().session;

    final courseUnitSheet =
        courseUnitsProvider.courseUnitsSheets[widget.courseUnit];
    if (courseUnitSheet == null || force) {
      await courseUnitsProvider.fetchCourseUnitSheet(
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
      length: 2,
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
              Tab(text: S.of(context).course_class)
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TabBarView(
                children: [
                  _courseUnitSheetView(context),
                  _courseUnitClassesView(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return LazyConsumer<CourseUnitsInfoProvider>(
      builder: (context, courseUnitsInfoProvider) {
        return RequestDependentWidgetBuilder(
          onNullContent: Center(
            child: Text(
              S.of(context).no_info,
              textAlign: TextAlign.center,
            ),
          ),
          status: courseUnitsInfoProvider.status,
          builder: () => CourseUnitSheetView(
            courseUnitsInfoProvider.courseUnitsSheets[widget.courseUnit]!,
          ),
          hasContentPredicate:
              courseUnitsInfoProvider.courseUnitsSheets[widget.courseUnit] !=
                      null &&
                  courseUnitsInfoProvider.courseUnitsSheets[widget.courseUnit]!
                      .sections.isNotEmpty,
        );
      },
    );
  }

  Widget _courseUnitClassesView(BuildContext context) {
    return LazyConsumer<CourseUnitsInfoProvider>(
      builder: (context, courseUnitsInfoProvider) {
        return RequestDependentWidgetBuilder(
          onNullContent: Center(
            child: Text(
              S.of(context).no_class,
              textAlign: TextAlign.center,
            ),
          ),
          status: courseUnitsInfoProvider.status,
          builder: () => CourseUnitClassesView(
            courseUnitsInfoProvider.courseUnitsClasses[widget.courseUnit]!,
          ),
          hasContentPredicate:
              courseUnitsInfoProvider.courseUnitsClasses[widget.courseUnit] !=
                      null &&
                  courseUnitsInfoProvider
                      .courseUnitsClasses[widget.courseUnit]!.isNotEmpty,
        );
      },
    );
  }
}

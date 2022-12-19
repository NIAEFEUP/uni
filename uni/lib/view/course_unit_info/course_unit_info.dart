import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/providers/course_units_info_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';

class CourseUnitDetailPageView extends StatefulWidget {
  final CourseUnit courseUnit;

  const CourseUnitDetailPageView(this.courseUnit, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitDetailPageViewState();
  }
}

class CourseUnitDetailPageViewState
    extends SecondaryPageViewState<CourseUnitDetailPageView> {
  @override
  void initState() {
    super.initState();

    // TODO: Handle this loading in a page generic way (#659)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseUnitsProvider =
          Provider.of<CourseUnitsInfoProvider>(context, listen: false);
      final session = context.read<SessionProvider>().session;

      final CourseUnitSheet? courseUnitSheet =
          courseUnitsProvider.courseUnitsSheets[widget.courseUnit];
      if (courseUnitSheet == null) {
        courseUnitsProvider.getCourseUnitSheet(widget.courseUnit, session);
      }

      final List<CourseUnitClass>? courseUnitClasses =
          courseUnitsProvider.courseUnitsClasses[widget.courseUnit];
      if (courseUnitClasses == null) {
        courseUnitsProvider.getCourseUnitClasses(widget.courseUnit, session);
      }
    });
  }

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PageTitle(
            center: false,
            name: widget.courseUnit.name,
          ),
          const TabBar(
            tabs: [Tab(text: "Ficha"), Tab(text: "Turmas")],
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
        ]));
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return Consumer<CourseUnitsInfoProvider>(
        builder: (context, courseUnitsInfoProvider, _) {
      return RequestDependentWidgetBuilder(
          context: context,
          status: courseUnitsInfoProvider.status,
          contentGenerator: (content, context) =>
              CourseUnitSheetView(widget.courseUnit.name, content),
          content: courseUnitsInfoProvider.courseUnitsSheets[widget.courseUnit],
          contentChecker:
              courseUnitsInfoProvider.courseUnitsSheets[widget.courseUnit] !=
                  null);
    });
  }

  Widget _courseUnitClassesView(BuildContext context) {
    return Text("Turmas");
  }
}

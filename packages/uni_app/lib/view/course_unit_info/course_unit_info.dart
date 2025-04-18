import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_no_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<Exam> courseUnitExams = [];

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
  Widget? getHeader(BuildContext context) {
    return null;
  }

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              TabIcon(icon: UniIcons.notebook, text: S.of(context).course_info),
              TabIcon(icon: UniIcons.classes, text: S.of(context).course_class),
              TabIcon(icon: UniIcons.files, text: S.of(context).files),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _courseUnitSheetView(context),
                _courseUnitClassesView(context),
                _courseUnitFilesView(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return Consumer<ExamProvider>(
      builder: (context, examProvider, child) {
        final sheet = context
            .read<CourseUnitsInfoProvider>()
            .courseUnitsSheets[widget.courseUnit];

        if (sheet == null) {
          return Center(
            child: Text(
              S.of(context).no_info,
              textAlign: TextAlign.center,
            ),
          );
        }

        final courseExams = (examProvider.state ?? [])
            .where(
              (exam) => exam.subjectAcronym == widget.courseUnit.abbreviation,
            )
            .toList();

        return CourseUnitSheetView(sheet, courseExams);
      },
    );
  }

  Widget _courseUnitFilesView(BuildContext context) {
    final files = context
        .watch<CourseUnitsInfoProvider>()
        .courseUnitsFiles[widget.courseUnit];

    if (files == null || files.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.only(bottom: 120),
            child: const Center(
              child: NoFilesWidget(),
            ),
          ),
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
  String? getTitle() => widget.courseUnit.name;

  @override
  Widget? getTopRightButton(BuildContext context) {
    return IconButton(
      icon: UniIcon(
        UniIcons.arrowSquareOut,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () async {
        // If the course unit isn't from FEUP, sigarra redirects to the correct page
        final url = Uri.parse(
          'https://sigarra.up.pt/feup/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=${widget.courseUnit.occurrId}',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
    );
  }
}

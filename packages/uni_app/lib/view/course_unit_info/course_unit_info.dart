import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/course_units_info_provider.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes_shimmer.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files_shimmer.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_no_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet_shimmer.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseUnitDetailPageView extends ConsumerStatefulWidget {
  const CourseUnitDetailPageView(this.courseUnit, {super.key});

  final CourseUnit courseUnit;

  @override
  ConsumerState<CourseUnitDetailPageView> createState() {
    return CourseUnitDetailPageViewState();
  }
}

class CourseUnitDetailPageViewState
    extends SecondaryPageViewState<CourseUnitDetailPageView>
    with SingleTickerProviderStateMixin {
  List<Exam> courseUnitExams = [];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  Future<void> loadInfo({required bool force}) async {
    final courseUnitsProvider = ref.read(courseUnitsInfoProvider.notifier);

    final courseUnitSheet =
        courseUnitsProvider.courseUnitsSheets[widget.courseUnit];
    if (courseUnitSheet == null || force) {
      await courseUnitsProvider.fetchCourseUnitSheet(widget.courseUnit);
    }

    final courseUnitFiles =
        courseUnitsProvider.courseUnitsFiles[widget.courseUnit];
    if (courseUnitFiles == null || force) {
      await courseUnitsProvider.fetchCourseUnitFiles(widget.courseUnit);
    }

    final courseUnitClasses =
        courseUnitsProvider.courseUnitsClasses[widget.courseUnit];
    if (courseUnitClasses == null || force) {
      await courseUnitsProvider.fetchCourseUnitClasses(widget.courseUnit);
    }
  }

  @override
  Future<void> onRefresh() async {
    await loadInfo(force: true);
  }

  @override
  Future<void> onLoad(BuildContext context) async {
    await loadInfo(force: false);
  }

  @override
  Widget? getHeader(BuildContext context) {
    return TabBar(
      controller: tabController,
      dividerHeight: 1,
      tabs: [
        TabIcon(icon: UniIcons.notebook, text: S.of(context).course_info),
        TabIcon(icon: UniIcons.classes, text: S.of(context).course_class),
        TabIcon(icon: UniIcons.files, text: S.of(context).files),
      ],
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _courseUnitSheetView(context),
        _courseUnitClassesView(context),
        _courseUnitFilesView(context),
      ],
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final sheet = ref
            .watch(courseUnitsInfoProvider.notifier)
            .courseUnitsSheets[widget.courseUnit];

        final exams = ref.watch(examProvider);

        final courseExams = exams.maybeWhen(
          data: (list) => list!
              .where(
                (exam) => exam.subjectAcronym == widget.courseUnit.abbreviation,
              )
              .toList(),
          orElse: () => <Exam>[],
        );

        if (sheet == null) {
          return const ShimmerCourseSheet();
        }

        return CourseUnitSheetView(sheet, courseExams);
      },
    );
  }

  Widget _courseUnitFilesView(BuildContext context) {
    final files = ref
        .read(courseUnitsInfoProvider.notifier)
        .courseUnitsFiles[widget.courseUnit];

    if (files == null) {
      return const ShimmerCourseFiles();
    }

    if (files.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.only(bottom: 120),
            child: const Center(child: NoFilesWidget()),
          ),
        ),
      );
    }

    return CourseUnitFilesView(files);
  }

  Widget _courseUnitClassesView(BuildContext context) {
    final classes = ref
        .read(courseUnitsInfoProvider.notifier)
        .courseUnitsClasses[widget.courseUnit];

    if (classes == null) {
      return const ShimmerCourseClasses();
    }

    if (classes.isEmpty) {
      return Center(
        child: Text(S.of(context).no_class, textAlign: TextAlign.center),
      );
    }

    return CourseUnitClassesView(classes);
  }

  @override
  String? getTitle() => widget.courseUnit.name;

  @override
  String? getSubtitle() => widget.courseUnit.schoolYear;

  @override
  Widget? getRightContent(BuildContext context) {
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

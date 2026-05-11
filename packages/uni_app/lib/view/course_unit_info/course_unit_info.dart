import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/course_units_info_provider.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/academic_path/widgets/no_classes_widget.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_shimmer.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes_shimmer.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files_shimmer.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_lectures.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_no_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_no_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_no_info.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet_shimmer.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseUnitDetailPageView extends ConsumerStatefulWidget {
  const CourseUnitDetailPageView(this.initialCourseUnit, {super.key});

  final CourseUnit initialCourseUnit;

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

  late CourseUnit courseUnit;

  @override
  void initState() {
    super.initState();
    courseUnit = widget.initialCourseUnit;
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (tabController.index == 1) {
      loadClasses(courseUnit, force: false);
    } else if (tabController.index == 2) {
      loadLectures(courseUnit, force: false);
    }
  }

  Future<void> loadInfo(CourseUnit courseUnit, {required bool force}) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }
    final occurs = await CourseUnitsInfoFetcher().fetchCourseUnitOccurences(
      session,
      courseUnit.occurrId!,
    );
    courseUnit.occurences = occurs;
    final courseUnitsProvider = ref.read(courseUnitsInfoProvider.notifier);

    final courseUnitSheet = courseUnitsProvider.courseUnitsSheets[courseUnit];
    if (courseUnitSheet == null || force) {
      await courseUnitsProvider.fetchCourseUnitSheet(courseUnit);
    }

    final courseUnitFiles = courseUnitsProvider.courseUnitsFiles[courseUnit];
    if (courseUnitFiles == null || force) {
      await courseUnitsProvider.fetchCourseUnitFiles(courseUnit);
    }
  }

  Future<void> loadClasses(CourseUnit courseUnit, {required bool force}) async {
    final courseUnitsProvider = ref.read(courseUnitsInfoProvider.notifier);

    final courseUnitClasses =
        courseUnitsProvider.courseUnitsClasses[courseUnit];
    if (courseUnitClasses == null || force) {
      await courseUnitsProvider.fetchCourseUnitClasses(courseUnit);
    }

    final courseUnitClassProfessors =
        courseUnitsProvider.courseUnitsClassProfessors[courseUnit];
    if (courseUnitClassProfessors == null || force) {
      await courseUnitsProvider.fetchClassProfessors(courseUnit);
    }
  }

  Future<void> loadLectures(
    CourseUnit courseUnit, {
    required bool force,
  }) async {
    final courseUnitsProvider = ref.read(courseUnitsInfoProvider.notifier);

    final courseUnitLectures =
        courseUnitsProvider.courseUnitsLectures[courseUnit];
    if (courseUnitLectures == null || force) {
      await courseUnitsProvider.fetchCourseUnitLectures(courseUnit);
    }
  }

  @override
  Future<void> onRefresh() async {
    await loadInfo(courseUnit, force: true);
    if (tabController.index == 1) {
      await loadClasses(courseUnit, force: true);
    } else if (tabController.index == 2) {
      await loadLectures(courseUnit, force: true);
    }
  }

  @override
  Future<void> onLoad(BuildContext context) async {
    await loadInfo(courseUnit, force: false);
    if (tabController.index == 1) {
      await loadClasses(courseUnit, force: false);
    } else if (tabController.index == 2) {
      await loadLectures(courseUnit, force: false);
    }
  }

  @override
  Widget? getHeader(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).colorScheme.onSecondary,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      dividerHeight: 0,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        TabIcon(icon: UniIcons.notebook, text: S.of(context).course_info),
        TabIcon(icon: UniIcons.classes, text: S.of(context).course_class),
        TabIcon(icon: UniIcons.lecture, text: S.of(context).lectures),
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
        _courseUnitLecturesView(context),
        _courseUnitFilesView(context),
      ],
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final sheet = ref
            .watch(courseUnitsInfoProvider.notifier)
            .courseUnitsSheets[courseUnit];

        final exams = ref.watch(examProvider);

        final courseExams = exams.maybeWhen(
          data: (list) => list!
              .where((exam) => exam.occurrId == courseUnit.occurrId.toString())
              .toList(),
          orElse: () => <Exam>[],
        );

        if (sheet == null) {
          return const ShimmerCourseSheet();
        }

        final hasNoInfo =
            sheet.professors.isEmpty &&
            sheet.content == 'null' &&
            sheet.evaluation == 'null' &&
            sheet.frequency == 'null' &&
            sheet.books.isEmpty;

        if (hasNoInfo) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: constraints.maxHeight,
                padding: const EdgeInsets.only(bottom: 120),
                child: const Center(child: NoInfoWidget()),
              ),
            ),
          );
        }

        return CourseUnitSheetView(sheet, courseExams);
      },
    );
  }

  Widget _courseUnitFilesView(BuildContext context) {
    final files = ref
        .read(courseUnitsInfoProvider.notifier)
        .courseUnitsFiles[courseUnit];

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
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(courseUnitsInfoProvider);
        final provider = ref.read(courseUnitsInfoProvider.notifier);

        final classes = provider.courseUnitsClasses[courseUnit];
        final sheet = provider.courseUnitsSheets[courseUnit];
        final classProfessors = provider.courseUnitsClassProfessors[courseUnit];

        if (classes == null) {
          return const Center(child: ShimmerCourseClasses());
        }

        if (classProfessors == null) {
          return const Center(child: ShimmerCourseClasses());
        }

        if (classes.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: constraints.maxHeight,
                padding: const EdgeInsets.only(bottom: 120),
                child: const Center(child: NoClassGroupsWidget()),
              ),
            ),
          );
        }

        return CourseUnitClassesView(
          classes,
          sheet?.professors ?? [],
          courseUnit,
          classProfessors: classProfessors,
        );
      },
    );
  }

  Widget _courseUnitLecturesView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(courseUnitsInfoProvider);
        final provider = ref.read(courseUnitsInfoProvider.notifier);

        final lectures = provider.courseUnitsLectures[courseUnit];

        if (lectures == null) {
          return const Center(child: ShimmerSchedulePage());
        }

        if (lectures.isEmpty) {
          return const Center(child: NoClassesWidget(showSublabel: false));
        }

        return CourseUnitLecturesView(lectures, courseUnit);
      },
    );
  }

  @override
  String? getTitle() => courseUnit.name;

  @override
  String? getSubtitle() => courseUnit.schoolYear;

  @override
  Widget? getSubtitleWidget() {
    var occurs = courseUnit.occurences;
    if (occurs == null || occurs.isEmpty) {
      occurs = {courseUnit.schoolYear!: courseUnit.occurrId!};
    }
    final years = occurs.keys.toList();

    final selectedItem = years.indexOf(courseUnit.schoolYear!);
    return Align(
      alignment: Alignment.bottomCenter,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
          value: years[selectedItem],
          elevation: 16,
          onChanged: (value) async {
            final nextOccur = CourseUnit(
              abbreviation: courseUnit.abbreviation,
              name: courseUnit.name,
              occurrId: occurs?[value],
              schoolYear: value,
            );
            // Preload data for the new course unit
            await loadInfo(nextOccur, force: false);
            if (tabController.index == 1) {
              await loadClasses(nextOccur, force: false);
            } else if (tabController.index == 2) {
              await loadLectures(nextOccur, force: false);
            }
            setState(() {
              courseUnit = nextOccur;
            });
          },
          items: years.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget? getRightContent(BuildContext context) {
    return IconButton(
      icon: UniIcon(
        UniIcons.arrowSquareOut,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      onPressed: () async {
        // If the course unit isn't from FEUP, sigarra redirects to the correct page
        final url = Uri.parse(
          'https://sigarra.up.pt/feup/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=${courseUnit.occurrId}',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
    );
  }

  @override
  void dispose() {
    tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/course_units_info_provider.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_classes.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet.dart';
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
  late TabController tabController;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(_onTabChanged);
    _tabs = [
      _courseUnitSheetView(context),
      _courseUnitClassesView(context),
      _courseUnitFilesView(context),
    ];
  }

  void _onTabChanged() {
    if (tabController.index == 1) {
      loadClasses(force: false);
    }
  }

  Future<void> loadInfo({required bool force}) async {
    final notifier = ref.read(courseUnitsInfoProvider.notifier);
    final stateValue = ref.read(courseUnitsInfoProvider).value;
    
    final futures = <Future<void>>[];
    final sheets = stateValue?.$1;
    if (sheets == null || !sheets.containsKey(widget.courseUnit) || force) {
      futures.add(notifier.fetchCourseUnitSheet(widget.courseUnit));
    }

    final files = stateValue?.$3;
    if (files == null || !files.containsKey(widget.courseUnit) || force) {
      futures.add(notifier.fetchCourseUnitFiles(widget.courseUnit));
    }
    
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> loadClasses({required bool force}) async {
    final notifier = ref.read(courseUnitsInfoProvider.notifier);
    final stateValue = ref.read(courseUnitsInfoProvider).value;
    
    final futures = <Future<void>>[];
    final classes = stateValue?.$2;
    if (classes == null || !classes.containsKey(widget.courseUnit) || force) {
      futures.add(notifier.fetchCourseUnitClasses(widget.courseUnit));
    }

    final classProfessors = stateValue?.$4;
    if (classProfessors == null || !classProfessors.containsKey(widget.courseUnit) || force) {
      futures.add(notifier.fetchClassProfessors(widget.courseUnit));
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  @override
  Future<void> onRefresh() async {
    await Future.wait([
      loadInfo(force: true),
      loadClasses(force: true),
    ]);
  }

  @override
  Future<void> onLoad(BuildContext context) async {
    unawaited(Future.wait([
      loadInfo(force: false),
      loadClasses(force: false),
    ]));
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
      children: _tabs,
    );
  }

  Widget _courseUnitSheetView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final sheet = ref.watch(courseUnitsInfoProvider.select(
          (s) => s.value?.$1[widget.courseUnit],
        ));

        final exams = ref.watch(examProvider);

        final courseExams = exams.maybeWhen(
          data: (list) => list
              ?.where(
                (exam) => exam.subjectAcronym == widget.courseUnit.abbreviation,
              )
              .toList() ?? [],
          orElse: () => <Exam>[],
        );

        if (sheet == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CourseUnitSheetView(sheet, courseExams);
      },
    );
  }

  Widget _courseUnitFilesView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final files = ref.watch(courseUnitsInfoProvider.select(
          (s) => s.value?.$3[widget.courseUnit],
        ));

        if (files == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CourseUnitFilesView(files);
      },
    );
  }

  Widget _courseUnitClassesView(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final classes = ref.watch(courseUnitsInfoProvider.select(
          (s) => s.value?.$2[widget.courseUnit],
        ));
        final sheet = ref.watch(courseUnitsInfoProvider.select(
          (s) => s.value?.$1[widget.courseUnit],
        ));
        final classProfessors = ref.watch(courseUnitsInfoProvider.select(
          (s) => s.value?.$4[widget.courseUnit],
        ));

        if (classes == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (classes.isEmpty) {
          return Center(
            child: Text(S.of(context).no_class, textAlign: TextAlign.center),
          );
        }

        if (classProfessors == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CourseUnitClassesView(
          classes,
          sheet?.professors ?? [],
          widget.courseUnit,
          classProfessors: classProfessors,
        );
      },
    );
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

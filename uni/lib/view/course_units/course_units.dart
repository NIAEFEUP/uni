import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/course_units/widgets/course_unit_card.dart';

class CourseUnitsPageView extends StatefulWidget {
  const CourseUnitsPageView({Key? key}) : super(key: key);

  static const bothSemestersDropdownOption = '1S+2S';

  @override
  State<StatefulWidget> createState() {
    return CourseUnitsPageViewState();
  }
}

class CourseUnitsPageViewState
    extends GeneralPageViewState<CourseUnitsPageView> {
  String? selectedSchoolYear;
  String? selectedSemester;

  @override
  Widget getBody(BuildContext context) {
    return Consumer<ProfileStateProvider>(
        builder: (context, profileProvider, _) {
      final List<CourseUnit> courseUnits = profileProvider.currUcs;
      List<String> availableYears = [];
      List<String> availableSemesters = [];
      if (courseUnits.isNotEmpty) {
        availableYears = _getAvailableYears(courseUnits);
        if (availableYears.isNotEmpty && selectedSchoolYear == null) {
          selectedSchoolYear = availableYears.reduce((value, element) =>
              element.compareTo(value) > 0 ? element : value);
        }
        availableSemesters = _getAvailableSemesters(courseUnits);
        final currentYear = int.tryParse(selectedSchoolYear?.substring(
                0, selectedSchoolYear?.indexOf('/')) ??
            '');
        if (selectedSemester == null &&
            currentYear != null &&
            availableSemesters.length == 3) {
          final currentDate = DateTime.now();
          selectedSemester =
              currentDate.year <= currentYear || currentDate.month == 1
                  ? availableSemesters[0]
                  : availableSemesters[1];
        }

        return _getPageView(courseUnits, profileProvider.status, availableYears,
            availableSemesters);
      } else {
        return Container();
      }
    });
  }

  Widget _getPageView(
      List<CourseUnit>? courseUnits,
      RequestStatus? requestStatus,
      List<String> availableYears,
      List<String> availableSemesters) {
    final List<CourseUnit>? filteredCourseUnits =
        selectedSemester == CourseUnitsPageView.bothSemestersDropdownOption
            ? courseUnits
                ?.where((element) => element.schoolYear == selectedSchoolYear)
                .toList()
            : courseUnits
                ?.where((element) =>
                    element.schoolYear == selectedSchoolYear &&
                    element.semesterCode == selectedSemester)
                .toList();
    return Column(children: [
      _getPageTitleAndFilters(availableYears, availableSemesters),
      RequestDependentWidgetBuilder(
          context: context,
          status: requestStatus ?? RequestStatus.none,
          contentGenerator: _generateCourseUnitsCards,
          content: filteredCourseUnits ?? [],
          contentChecker: courseUnits?.isNotEmpty ?? false,
          onNullContent: Center(
            heightFactor: 10,
            child: Text('Não existem cadeiras para apresentar',
                style: Theme.of(context).textTheme.headline6),
          ))
    ]);
  }

  Widget _getPageTitleAndFilters(
      List<String> availableYears, List<String> availableSemesters) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PageTitle(name: DrawerItem.navCourseUnits.title),
        const Spacer(),
        DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          alignment: AlignmentDirectional.centerEnd,
          disabledHint: const Text('Semestre'),
          value: selectedSemester,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() => selectedSemester = newValue!);
          },
          items:
              availableSemesters.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
        const SizedBox(width: 10),
        DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          disabledHint: const Text('Ano'),
          value: selectedSchoolYear,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() => selectedSchoolYear = newValue!);
          },
          items: availableYears.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
        const SizedBox(width: 20)
      ],
    );
  }

  Widget _generateCourseUnitsCards(courseUnits, context) {
    if ((courseUnits as List<CourseUnit>).isEmpty) {
      return Center(
          heightFactor: 10,
          child: Text('Sem cadeiras no período selecionado',
              style: Theme.of(context).textTheme.headline6));
    }
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: _generateCourseUnitsGridView(courseUnits),
            )));
  }

  List<Widget> _generateCourseUnitsGridView(List<CourseUnit> courseUnits) {
    final List<Widget> rows = [];
    for (var i = 0; i < courseUnits.length; i += 2) {
      if (i < courseUnits.length - 1) {
        rows.add(IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Flexible(child: CourseUnitCard(courseUnits[i])),
          const SizedBox(width: 10),
          Flexible(child: CourseUnitCard(courseUnits[i + 1])),
        ])));
      } else {
        rows.add(Row(children: [
          Flexible(child: CourseUnitCard(courseUnits[i])),
          const SizedBox(width: 10),
          const Spacer()
        ]));
      }
    }
    return rows;
  }

  List<String> _getAvailableYears(List<CourseUnit> courseUnits) {
    return courseUnits
        .map((c) => c.schoolYear)
        .whereType<String>()
        .toSet()
        .toList()
        .sorted();
  }

  List<String> _getAvailableSemesters(List<CourseUnit> courseUnits) {
    return courseUnits
            .map((c) => c.semesterCode)
            .whereType<String>()
            .toSet()
            .toList()
            .sorted() +
        [CourseUnitsPageView.bothSemestersDropdownOption];
  }
}

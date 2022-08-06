import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/course_unit_card.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';

class CourseUnitsPageView extends StatefulWidget {
  const CourseUnitsPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitsPageViewState();
  }
}

class CourseUnitsPageViewState
    extends SecondaryPageViewState<CourseUnitsPageView> {
  String? selectedSchoolYear;
  String? selectedSemester;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<
            AppState,
            Tuple4<List<CourseUnit>?, RequestStatus?, List<String>,
                List<String>>>(
        converter: (store) {
          List<CourseUnit>? courseUnits = store.state.content['allUcs'];
          List<String> availableYears = [];
          List<String> availableSemesters = [];
          if (courseUnits != null && courseUnits.isNotEmpty) {
            availableYears = _getAvailableYears(courseUnits);
            availableYears.sort();
            if (availableYears.isNotEmpty && selectedSchoolYear == null) {
              selectedSchoolYear = availableYears.reduce((value, element) =>
                  element.compareTo(value) > 0 ? element : value);
            }
            availableSemesters = _getAvailableSemesters(courseUnits);
            availableSemesters.sort();
            if (availableSemesters.length >= 2 && selectedSemester == null) {
              DateTime now = DateTime.now();
              bool secondSemesterPeriod = now.month > 2 && now.month < 9;
              selectedSemester = secondSemesterPeriod
                  ? availableSemesters[1]
                  : availableSemesters[0];
            }
          }
          return Tuple4(
              store.state.content['allUcs'],
              store.state.content['allUcsStatus'],
              availableYears,
              availableSemesters);
        },
        builder: (context, ucsInfo) => getPageContents(
            ucsInfo.item1, ucsInfo.item2, ucsInfo.item3, ucsInfo.item4));
  }

  Widget getPageContents(
      List<CourseUnit>? courseUnits,
      RequestStatus? requestStatus,
      List<String> availableYears,
      List<String> availableSemesters) {
    List<CourseUnit>? filteredCourseUnits = courseUnits
        ?.where((element) =>
            element.schoolYear == selectedSchoolYear &&
            element.semesterCode == selectedSemester)
        .toList();
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const PageTitle(name: constants.navCourseUnits),
          const Spacer(),
          DropdownButton<String>(
            disabledHint: const Text('Ano'),
            value: selectedSchoolYear,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() => selectedSchoolYear = newValue!);
            },
            items: availableYears.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(value)),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            disabledHint: const Text('Semestre'),
            value: selectedSemester,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() => selectedSemester = newValue!);
            },
            items: availableSemesters
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(value)),
              );
            }).toList(),
          ),
          const SizedBox(width: 20)
        ],
      ),
      RequestDependentWidgetBuilder(
          context: context,
          status: requestStatus ?? RequestStatus.none,
          contentGenerator: generateCourseUnitsCards,
          content: filteredCourseUnits ?? [],
          contentChecker: courseUnits?.isNotEmpty ?? false,
          onNullContent: Center(
            heightFactor: 10,
            child: Text('Não existem cadeiras para apresentar',
                style: Theme.of(context).textTheme.headline6),
          ))
    ]);
  }

  Widget generateCourseUnitsCards(courseUnits, context) {
    if ((courseUnits as List<CourseUnit>).isEmpty) {
      return Center(
          heightFactor: 10,
          child: Text('Sem cadeiras no período selecionado',
              style: Theme.of(context).textTheme.headline6));
    }

    List<Widget> rows = [];
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

    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: rows,
            )));
  }
}

List<String> _getAvailableYears(List<CourseUnit> courseUnits) {
  return courseUnits
      .map((c) => c.schoolYear)
      .whereType<String>()
      .toSet()
      .toList();
}

List<String> _getAvailableSemesters(List<CourseUnit> courseUnits) {
  return courseUnits
      .map((c) => c.semesterCode)
      .whereType<String>()
      .toSet()
      .toList();
}

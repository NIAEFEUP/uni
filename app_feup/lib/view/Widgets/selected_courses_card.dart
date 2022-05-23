import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/view/Pages/selected_course_units_page_view.dart';
import 'package:uni/view/Widgets/section_card.dart';

class SelectedCoursesCard extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  SelectedCoursesCard({Key key, this.selectedCourseUnits, this.courseUnits})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectedCoursesCardState(
      selectedCourseUnits: this.selectedCourseUnits,
      courseUnits: this.courseUnits,
    );
  }
}

class SelectedCoursesCardState extends State<SelectedCoursesCard> {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  SelectedCoursesCardState({this.selectedCourseUnits, this.courseUnits});

  @override
  Widget build(BuildContext context) {
    final List<String> courseUnitsAbbreviated = selectedCourseUnits.selected
        ?.map((courseUnit) => courseUnit.abbreviation)
        ?.toList();
    courseUnitsAbbreviated.sort();

    return SectionCard(
      onClick: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedCourseUnitsPageView(
            selectedCourseUnits,
            courseUnits,
          ),
        ),
      ).then((value) => setState(() {})),
      content: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).accentColor,
            ),
          ),
          Column(
            children: selectedCourseUnits.selected.isEmpty
                ? [
                    Text('Nenhuma unidade curricular'),
                    Text('selecionada'),
                    SizedBox(height: 10)
                  ]
                : [
                    Text('Unidades curriculares selecionadas:'),
                    Text(
                      courseUnitsAbbreviated.join(', '),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(color: Theme.of(context).accentColor),
                    ),
                    SizedBox(height: 10)
                  ],
          ),
        ],
      ),
    );
  }
}

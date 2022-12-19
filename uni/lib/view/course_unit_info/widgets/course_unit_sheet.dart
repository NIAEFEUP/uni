import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  final CourseUnitSheet courseUnitSheet;
  final String courseUnitName;

  const CourseUnitSheetView(this.courseUnitName, this.courseUnitSheet,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final List<CourseUnitSheetCard> cards = [];
    for (var section in courseUnitSheet.sections.entries) {
      cards.add(CourseUnitSheetCard(
          section.key,
          HtmlWidget(
            section.value,
            renderMode: RenderMode.column,
            onTapUrl: (url) {
              print('tapped $url');
              return false;
            },
          )));
    }

    return Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(children: cards) //ListView(children: sections)),
            ));
  }
}

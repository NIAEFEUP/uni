import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/course_units/sheet.dart';

import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, {super.key});
  final Sheet courseUnitSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: courseUnitSheet.sections.entries
                .map((e) => _buildCard(e.key, e.value))
                .toList(),
          ),
        ));
  }

  Widget _buildCard(
    String sectionTitle,
    dynamic sectionContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: [
        const Opacity(
          opacity: 0.25,
          child: Divider(color: Colors.grey),
        ),
        CourseUnitInfoCard(
          sectionTitle,
          HtmlWidget(sectionContent.toString()),
        ),
      ]),
    );
  }
}

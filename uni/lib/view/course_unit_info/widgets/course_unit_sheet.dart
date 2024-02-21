import 'dart:math';

import 'package:flutter/material.dart';
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
      child: ListView(
        children: courseUnitSheet.sections.entries
            .map((e) => _buildCard(e.key, e.value))
            .toList(),
      ),
    );
  }

  CourseUnitInfoCard _buildCard(
    String sectionTitle,
    dynamic sectionContent,
  ) {
    return CourseUnitInfoCard(
      sectionTitle,
      Container(
        child: sectionContent is String || sectionContent is int
            ? Text(sectionContent.toString())
            : sectionContent is List<dynamic>
                ? Column(
                    children: sectionContent
                        .map((item) => Text(item.toString()))
                        .toList(),
                  )
                : sectionContent as Widget?,
      ),
    );
  }
}

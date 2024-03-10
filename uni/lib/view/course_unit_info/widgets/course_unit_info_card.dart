import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expandable.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';

class CourseUnitInfoCard extends GenericExpandable {
  CourseUnitInfoCard(this.sectionTitle, this.info, {super.key})
      : super(
          title: normalizeTitle(sectionTitle),
          content: info,
        );
  final String sectionTitle;
  final Widget info;
}

String normalizeTitle(String sectionTitle) {
  return sectionTitle[0].toUpperCase() + sectionTitle.substring(1);
}

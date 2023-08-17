import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';

class CourseUnitInfoCard extends GenericExpansionCard {
  const CourseUnitInfoCard(this.sectionTitle, this.content, {super.key})
      : super(
          cardMargin: const EdgeInsets.only(bottom: 10),
          smallTitle: true,
        );
  final String sectionTitle;
  final Widget content;

  @override
  Widget buildCardContent(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 10), child: content);
  }

  @override
  String getTitle() {
    return sectionTitle;
  }
}

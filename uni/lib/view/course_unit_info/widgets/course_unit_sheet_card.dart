import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';

class CourseUnitSheetCard extends GenericExpansionCard {
  final String sectionTitle;
  final Widget content;

  const CourseUnitSheetCard(this.sectionTitle, this.content, {key})
      : super(
            key: key,
            cardMargin: const EdgeInsets.only(bottom: 10),
            smallTitle: true);

  @override
  Widget buildCardContent(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 10), child: content);
  }

  @override
  String getTitle() {
    return sectionTitle;
  }
}

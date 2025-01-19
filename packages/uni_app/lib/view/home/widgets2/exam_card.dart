import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/generic_homecard.dart';
import 'package:uni_ui/cards/exam_card.dart';

class ExamHomeCard extends GenericHomecard {
  const ExamHomeCard({
    required super.title,
    super.key,
  });

  @override
  Widget buildCardContent(BuildContext context) {
    return const Column(
      children: [
        ExamCard(
          name: 'Computer Lab',
          acronym: 'LCOM',
          rooms: ['B333', 'B314'],
          type: 'MT',
        ),
        ExamCard(
          name: 'Computer Lab',
          acronym: 'LCOM',
          rooms: ['B333', 'B314'],
          type: 'MT',
        ),
      ],
    );
  }
}

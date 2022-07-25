import 'package:flutter/material.dart';
import 'package:uni/view/Pages/Exams/widgets/exam_filter_menu.dart';
import 'package:uni/view/Common/page_title.dart';

class ExamPageTitleFilter extends StatelessWidget {
  final String name;

  const ExamPageTitleFilter({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          PageTitle(name: 'Exames', center: false),
          Material(child: ExamFilterMenu()),
        ],
      ),
    );
  }
}

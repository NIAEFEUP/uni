import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/exams/widgets/exam_filter_menu.dart';

class ExamPageTitle extends StatelessWidget {
  const ExamPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageTitle(
            name: S.of(context).nav_title(DrawerItem.navExams.title),
            center: false,
            pad: false,
          ),
          Material(child: ExamFilterMenu()),
        ],
      ),
    );
  }
}

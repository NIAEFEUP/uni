import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/academic_path/widgets/course_units_card.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/exam_card.dart';
import 'package:uni/view/home/widgets/schedule_card.dart';

class AcademicPathPageView extends StatefulWidget {
  const AcademicPathPageView({super.key});

  @override
  State<StatefulWidget> createState() => AcademicPathPageViewState();
}

class AcademicPathPageViewState extends GeneralPageViewState {
  List<GenericCard> academicPathCards = [
    ScheduleCard(),
    ExamCard(),
    CourseUnitsCard(),
    // Add more cards if needed
  ];

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        PageTitle(
          name: S.of(context).nav_title(DrawerItem.navAcademicPath.title),
        ),
        Column(
          children: academicPathCards,
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    for (final card in academicPathCards) {
      card.onRefresh(context);
    }
  }
}

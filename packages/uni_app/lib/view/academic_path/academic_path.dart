import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/academic_path/widgets/course_units_card.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
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
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navAcademicPath.route);

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: academicPathCards,
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    for (final card in academicPathCards) {
      card.onRefresh(context);
    }
  }
}

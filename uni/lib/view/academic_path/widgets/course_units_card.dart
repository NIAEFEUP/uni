import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/course_units/widgets/course_unit_card.dart';
import 'package:uni/view/lazy_consumer.dart';

class CourseUnitsCard extends GenericCard {
  CourseUnitsCard({super.key});

  @override
  void onRefresh(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) {
        final courseUnits = profile.courseUnits;

        return _generateCourseUnitsCards(courseUnits, context);
      },
      hasContent: (Profile profile) => profile.courseUnits.isNotEmpty,
      onNullContent: Center(
        heightFactor: 10,
        child: Text(
          S.of(context).no_course_units,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _generateCourseUnitsCards(
      List<CourseUnit> courseUnits,
      BuildContext context,
      ) {
    if (courseUnits.isEmpty) {
      return Center(
        heightFactor: 10,
        child: Text(
          S.of(context).no_course_units,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: _generateCourseUnitsList(courseUnits),
        ),
      ),
    );
  }

  List<Widget> _generateCourseUnitsList(List<CourseUnit> courseUnits) {
    return courseUnits.map((courseUnit) {
      return Column(
        children: [
          CourseUnitCard(courseUnit),
          const SizedBox(height: 10),
        ],
      );
    }).toList();
  }

  @override
  String getTitle(BuildContext context) => 'Current Course Units';

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navCourseUnits.title}');
}
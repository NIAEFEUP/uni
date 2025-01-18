import 'package:flutter/material.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/course_grade_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LazyConsumer<ProfileProvider, Profile>(
        builder: (context, profile) {
          final courses = profile.courses;
          final course = courses[0];
          final courseUnits = profile.courseUnits;

          return ListView(
            children: [
              Text(
                course.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GridView.count(
                crossAxisCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 2,
                children: courseUnits
                    .where((unit) =>
                        unit.curricularYear?.toString() == course.currYear)
                    .map((unit) {
                  return CourseGradeCard(
                    courseName: unit.name,
                    ects: unit.ects! as double,
                    grade: unit.grade != null
                        ? double.tryParse(unit.grade!)?.round()
                        : null,
                  );
                }).toList(),
              ),
            ],
          );
        },
        hasContent: (profile) => profile.courses.isNotEmpty,
        onNullContent: Container(),
      ),
    );
  }
}

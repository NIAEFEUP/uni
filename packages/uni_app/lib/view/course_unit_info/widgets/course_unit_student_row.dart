import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni_ui/theme.dart';

class CourseUnitStudentRow extends StatelessWidget {
  const CourseUnitStudentRow(this.student, this.session, {super.key});

  final CourseUnitStudent student;
  final Session session;

  @override
  Widget build(BuildContext context) {
    final userImage = ProfileProvider.fetchOrGetCachedProfilePicture(
      session,
      studentNumber: student.number,
    );
    return FutureBuilder(
      builder: (context, snapshot) {
        final names = student.name.split(RegExp(r'\s+'));
        final firstName = names.first;
        final lastName = names.last;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: snapshot.hasData && snapshot.data!.lengthSync() > 0
                      ? FileImage(snapshot.data!) as ImageProvider
                      : const AssetImage(
                          'assets/images/profile_placeholder.png',
                        ),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        firstName,
                        overflow: TextOverflow.fade,
                        style: lightTheme.textTheme.titleLarge?.copyWith(
                          color: grayText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        lastName,
                        overflow: TextOverflow.ellipsis,
                        style: lightTheme.textTheme.titleLarge?.copyWith(
                          color: grayText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
      future: userImage,
    );
  }
}

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                aspectRatio: 1, // Ensures square shape
                child: Container(), // Empty child to enforce aspect ratio
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4), // Add padding for better alignment
                child: Text(
                  '${student.name.split(RegExp(r'\s+')).first} ${student.name.split(RegExp(r'\s+')).last}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Allow up to two lines for the name
                  style: lightTheme.textTheme.headlineSmall?.copyWith(
                    color: grayText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
      future: userImage,
    );
  }
}

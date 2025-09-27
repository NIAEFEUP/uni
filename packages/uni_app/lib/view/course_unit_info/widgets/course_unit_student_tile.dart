import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/view/course_unit_info/widgets/modal_student_info.dart';

class CourseUnitStudentTile extends StatelessWidget {
  const CourseUnitStudentTile(this.student, this.session, {super.key});

  final CourseUnitStudent student;
  final Session session;

  @override
  Widget build(BuildContext context) {
    final userImage = ProfileProvider.fetchOrGetCachedProfilePicture(
      session,
      studentNumber: student.number,
    );
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => StudentInfoModal(student),
        );
      },
      child: FutureBuilder(
        builder: (context, snapshot) {
          final names = student.name.split(RegExp(r'\s+'));
          final firstName = names.first;
          final lastName = names.last;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withAlpha(0x3f),
                      blurRadius: 10,
                    ),
                  ],
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 25,
                      cornerSmoothing: 1,
                    ),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        snapshot.hasData && snapshot.data!.lengthSync() > 0
                            ? FileImage(snapshot.data!) as ImageProvider
                            : const AssetImage(
                              'assets/images/profile_placeholder.png',
                            ),
                  ),
                ),
                child: AspectRatio(aspectRatio: 1, child: Container()),
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
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: const Color.fromARGB(255, 48, 48, 48),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          lastName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: const Color.fromARGB(255, 48, 48, 48),
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
      ),
    );
  }
}

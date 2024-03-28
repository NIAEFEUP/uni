import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';

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
        return Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: snapshot.hasData && snapshot.data!.lengthSync() > 0
                        ? FileImage(snapshot.data!) as ImageProvider
                        : const AssetImage(
                            'assets/images/profile_placeholder.png',
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          'up${student.number}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      future: userImage,
    );
  }
}

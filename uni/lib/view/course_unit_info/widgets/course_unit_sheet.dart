import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/generic_animated_expandable.dart';
import 'package:uni/view/common_widgets/generic_expandable.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, {super.key});
  final Sheet courseUnitSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regentes',
              style: TextStyle(fontSize: 18),
            ),
            buildRegentsRow(context, courseUnitSheet.regents),
            const Text(
              'Docentes',
              style: TextStyle(fontSize: 18),
            ),
            AnimatedExpandable(
              firstChild:
                  buildProfessorsRow(context, courseUnitSheet.professors),
              secondChild:
                  buildExpandedProfessors(context, courseUnitSheet.professors),
            ),
            _buildCard('Programa', courseUnitSheet.content),
            _buildCard('Avaliação', courseUnitSheet.evaluation),
          ],
        ),
      ),
    );
  }
}

Widget buildRegentsRow(BuildContext context, List<Professor> regents) {
  final session = context.read<SessionProvider>().state!;
  return SizedBox(
    height: (regents.length * 80) + 20,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...regents.asMap().entries.map((regent) {
          final idx = regent.key;
          return Padding(
            padding: EdgeInsets.only(bottom: idx == regents.length - 1 ? 0 : 5),
            child: Row(
              children: [
                FutureBuilder<File?>(
                  builder:
                      (BuildContext context, AsyncSnapshot<File?> snapshot) =>
                          _buildAvatar(snapshot, 40),
                  future: ProfileProvider.fetchOrGetCachedProfilePicture(
                    session,
                    studentNumber: int.parse(regent.value.code),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        regent.value.name,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}

Widget buildProfessorsRow(BuildContext context, List<Professor> professors) {
  final session = context.read<SessionProvider>().state!;
  return SizedBox(
    height: 55,
    width: double.infinity,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...professors.asMap().entries.map((professor) {
            final idx = professor.key;
            return Row(
              children: [
                FutureBuilder<File?>(
                  builder:
                      (BuildContext context, AsyncSnapshot<File?> snapshot) =>
                          Transform.translate(
                    offset: Offset(-10.0 * idx, 0),
                    child: _buildAvatar(snapshot, 20),
                  ),
                  future: ProfileProvider.fetchOrGetCachedProfilePicture(
                    session,
                    studentNumber: int.parse(professor.value.code),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    ),
  );
}

Widget buildExpandedProfessors(
  BuildContext context,
  List<Professor> professors,
) {
  final session = context.read<SessionProvider>().state!;
  return SizedBox(
    height: (professors.length * 45) + 10,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...professors.asMap().entries.map((professor) {
          final idx = professor.key;
          return Padding(
            padding:
                EdgeInsets.only(bottom: idx == professors.length - 1 ? 0 : 5),
            child: Row(
              children: [
                FutureBuilder<File?>(
                  builder:
                      (BuildContext context, AsyncSnapshot<File?> snapshot) =>
                          _buildAvatar(snapshot, 20),
                  future: ProfileProvider.fetchOrGetCachedProfilePicture(
                    session,
                    studentNumber: int.parse(professor.value.code),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professor.value.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}

Widget _buildCard(
  String sectionTitle,
  dynamic sectionContent,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        const Opacity(
          opacity: 0.25,
          child: Divider(color: Colors.grey),
        ),
        GenericExpandable(
          content: HtmlWidget(sectionContent.toString()),
          title: sectionTitle,
        ),
      ],
    ),
  );
}

Widget _buildAvatar(AsyncSnapshot<File?> snapshot, double radius) {
  return CircleAvatar(
    radius: radius,
    backgroundImage: snapshot.hasData && snapshot.data != null
        ? FileImage(snapshot.data!) as ImageProvider
        : const AssetImage(
            'assets/images/profile_placeholder.png',
          ),
  );
}

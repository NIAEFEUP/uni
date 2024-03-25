import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/generic_expandable.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, {super.key});
  final Sheet courseUnitSheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
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
                showProfessors(
                  context,
                  snapshot.data?.regents ?? [],
                  regent: true,
                ),
                const Text(
                  'Docentes',
                  style: TextStyle(fontSize: 18),
                ),
                showProfessors(
                  context,
                  snapshot.data?.professors ?? [],
                  regent: false,
                ),
                _buildCard('Programa', courseUnitSheet.content),
                _buildCard('Avaliação', courseUnitSheet.evaluation),
              ],
            ),
          ),
        );
      },
      future: Future.value(courseUnitSheet),
    );
  }

  Widget showProfessors(BuildContext context, List<Professor> professors,
      {required bool regent}) {
    final session = context.read<SessionProvider>().state!;
    return SizedBox(
      height: regent ? 100 : 75,
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
                        (BuildContext context, AsyncSnapshot<File?> snapshot) {
                      if (regent) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              snapshot.hasData && snapshot.data != null
                                  ? FileImage(snapshot.data!) as ImageProvider
                                  : const AssetImage(
                                      'assets/images/profile_placeholder.png',
                                    ),
                        );
                      } else {
                        return Transform.translate(
                          offset: Offset(-10.0 * idx, 0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                snapshot.hasData && snapshot.data != null
                                    ? FileImage(snapshot.data!) as ImageProvider
                                    : const AssetImage(
                                        'assets/images/profile_placeholder.png',
                                      ),
                          ),
                        );
                      }
                    },
                    future: ProfileProvider.fetchOrGetCachedProfilePicture(
                      session,
                      studentNumber: int.parse(professor.value.code),
                    ),
                  ),
                  if (regent)
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
                            professor.value.name,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
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
}

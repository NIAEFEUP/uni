import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';

import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, {super.key});
  final Sheet courseUnitSheet;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;

    courseUnitSheet.regents.forEach((element) async {
      element.picture = await ProfileProvider.fetchOrGetCachedProfilePicture(
        session,
        studentNumber: int.parse(element.code),
      );
    });

    courseUnitSheet.professors.forEach((element) async {
      element.picture = await ProfileProvider.fetchOrGetCachedProfilePicture(
        session,
        studentNumber: int.parse(element.code),
      );
    });

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Regentes',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...(snapshot.data?.regents ?? []).map((regent) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: regent.picture != null
                                  ? FileImage(regent.picture!) as ImageProvider
                                  : const AssetImage(
                                      'assets/images/profile_placeholder.png',
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
                                    regent.name,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  const Text('Regente')
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const Text(
                'Docentes',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...(snapshot.data?.professors ?? [])
                            .asMap()
                            .entries
                            .map((professor) {
                          final idx = professor.key;
                          return Transform.translate(
                            offset: Offset(-10.0 * idx, 0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: professor.value.picture != null
                                  ? FileImage(professor.value.picture!)
                                      as ImageProvider
                                  : const AssetImage(
                                      'assets/images/profile_placeholder.png',
                                    ),
                            ),
                          );
                        })
                      ],
                    ),
                  ))
            ],
          ),
        );
      },
      future: Future.value(courseUnitSheet),
    );
  }

  Widget _buildCard(
    String sectionTitle,
    dynamic sectionContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: [
        const Opacity(
          opacity: 0.25,
          child: Divider(color: Colors.grey),
        ),
        CourseUnitInfoCard(
          sectionTitle,
          HtmlWidget(sectionContent.toString()),
        ),
      ]),
    );
  }
}

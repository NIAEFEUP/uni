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

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Professor>> snapshot) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    ...(snapshot.data ?? []).map((regent) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: regent.picture != null
                            ? FileImage(regent.picture!) as ImageProvider
                            : const AssetImage(
                                'assets/images/profile_placeholder.png',
                              ), // Provide path to your default image asset
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      future: Future.value(courseUnitSheet.regents),
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

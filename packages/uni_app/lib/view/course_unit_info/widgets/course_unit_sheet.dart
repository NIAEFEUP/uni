import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/fetchers/book_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/generic_animated_expandable.dart';
import 'package:uni/view/common_widgets/generic_expandable.dart';
import 'package:uni/view/course_unit_info/widgets/modal_professor_info.dart';
import 'package:uni_ui/cards/exam_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, this.exams, {super.key});
  final Sheet courseUnitSheet;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instructors',
              style: TextStyle(fontSize: 20),
            ),
            if (courseUnitSheet.professors.length <= 4)
              buildInstructorsRow(context, courseUnitSheet.professors) 
            else
              AnimatedExpandable(
                firstChild: buildLimitedInstructorsRow(
                    context, courseUnitSheet.professors),
                secondChild:
                    buildInstructorsRow(context, courseUnitSheet.professors),
              ),
            const Opacity(
              opacity: 0.25,
              child: Divider(color: Colors.grey),
            ),
            const Text(
              'Assessments',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: buildExamsRow(context, exams),
              ),
            ),
            _buildCard(S.of(context).program, courseUnitSheet.content, context),
            _buildCard(
              S.of(context).evaluation,
              courseUnitSheet.evaluation,
              context,
            ),
            if (courseUnitSheet.books.isNotEmpty) ...[
              const Opacity(
                opacity: 0.25,
                child: Divider(color: Colors.grey),
              ),
              Text(
                S.of(context).bibliography,
                style: const TextStyle(fontSize: 20),
              ),
              buildBooksRow(context, courseUnitSheet.books),
            ],
          ],
        ),
      ),
    );
  }
}

Widget buildLimitedInstructorsRow(
    BuildContext context, List<Professor> instructors) {
  final session = context.read<SessionProvider>().state!;
  final firstThree = instructors.take(3).toList();
  final remaining = instructors.skip(3).toList();

  List<Widget> children = [];
  for (final instructor in firstThree) {
    children.add(Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 245, 243, 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<File?>(
            builder: (context, snapshot) => _buildAvatar(snapshot, 20),
            future: ProfileProvider.fetchOrGetCachedProfilePicture(
              session,
              studentNumber: int.parse(instructor.code),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  instructor.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Text(
                'Lead Instructor',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  if (remaining.isNotEmpty) {
    children.add(
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 245, 243, 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70,
              height: 40,
              child: Stack( // Use Stack for overlapping
                children: remaining.asMap().entries.map((entry) {
                  final index = entry.key;
                  final instructor = entry.value;
                  return Positioned(
                    left: index * 24.0, // Adjust this value for desired overlap
                    child: FutureBuilder<File?>(
                      builder: (context, snapshot) => _buildAvatar(snapshot, 20),
                      future: ProfileProvider.fetchOrGetCachedProfilePicture(
                        session,
                        studentNumber: int.parse(instructor.code),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+${remaining.length} more',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: children,
  );
}

Widget buildInstructorsRow(
    BuildContext context, List<Professor> instructors) {
  final session = context.read<SessionProvider>().state!;
  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: instructors.map((instructor) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 245, 243, 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<File?>(
              builder: (context, snapshot) => _buildAvatar(snapshot, 20),
              future: ProfileProvider.fetchOrGetCachedProfilePicture(
                session,
                studentNumber: int.parse(instructor.code),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    instructor.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  'Lead Instructor',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget buildExamsRow(BuildContext context, List<Exam> exams) {
  bool isMock = false;

  if (isMock) {
      final List<Exam> mockExams = [
      Exam(
        'mock1',
        DateTime(2024, 12, 10, 9, 0),
        DateTime(2024, 12, 10, 11, 0),
        'SDLE',
        ['B315', 'B224', 'B207'],
        'MT',
        'Faculty of Science',
      ),
      Exam(
        'mock2',
        DateTime(2025, 01, 15, 14, 30),
        DateTime(2025, 01, 15, 16, 00),
        'SDLE',
        ['B315', 'B224', 'B207'],
        'EN',
        'Faculty of Science',
      ),
      Exam(
        'mock3',
        DateTime(2025, 02, 20, 10, 00),
        DateTime(2025, 02, 20, 12, 30),
        'SDLE',
        ['FC4126'],
        'ER',
        'Faculty of Science',
      ),
    ];
    return Row(
      children: mockExams.map((exam) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 240,
            child: ExamCard(
              name: 'Sistemas Distribuídos de Larga Escala',
              acronym: exam.subject,
              rooms: exam.rooms,
              type: exam.examType,
              startTime: exam.startTime,
              examDay: exam.start.day.toString(),
              examMonth: exam.monthAcronym(PreferencesController.getLocale()),
              showIcon: false,
            ),
          ),
        );
      }).toList(),
    );
  }

  if(exams.isEmpty) {
    return const Center(
      child: Text('No exams scheduled'),
    );
  }

  return Row(
    children: exams.map((exam) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SizedBox(
          width: 240,
          child: ExamCard(
            name: exam.subject,
            acronym: exam.subject,
            rooms: exam.rooms,
            type: exam.examType,
            startTime: exam.startTime,
            examDay: exam.start.day.toString(),
            examMonth: exam.monthAcronym(PreferencesController.getLocale()),
            showIcon: false,
          ),
        ),
      );
    }).toList(),
  );
}

Widget buildBooksRow(BuildContext context, List<Book> books) {
  return Wrap(
    alignment: WrapAlignment.spaceBetween,
    children: [
      ...books.asMap().entries.map((book) {
        return FutureBuilder<String?>(
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: 135,
                    height: 140,
                    child: snapshot.data != null
                        ? Image(image: NetworkImage(snapshot.data!))
                        : const Image(
                            image: AssetImage(
                              'assets/images/book_placeholder.png',
                            ),
                          ),
                  ),
                  SizedBox(
                    width: 135,
                    child: Text(
                      book.value.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
          future: BookThumbFetcher().fetchBookThumb(book.value.isbn),
        );
      }),
    ],
  );
}

Widget _buildCard(
  String sectionTitle,
  String sectionContent,
  BuildContext context,
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
          content: HtmlWidget(
            sectionContent != 'null' ? sectionContent : S.of(context).no_info,
          ),
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
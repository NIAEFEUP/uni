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
import 'package:uni_ui/cards/instructor_card.dart';
import 'package:uni_ui/cards/remaining_instructors_card.dart';

const double _bookCardWidth = 135;
const double _bookCardHeight = 140;
const double _instructorSpacing = 8;
const double _instructorRunSpacing = 4;

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, this.exams, {super.key});

  final Sheet courseUnitSheet;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          _buildInstructorsSection(context),
          _buildExamsSection(context),
          _buildContentCard(
            S.of(context).program,
            courseUnitSheet.content,
            context,
          ),
          _buildContentCard(
            S.of(context).evaluation,
            courseUnitSheet.evaluation,
            context,
          ),
          _buildContentCard(
            S.of(context).frequency,
            courseUnitSheet.frequency,
            context,
          ),
          if (courseUnitSheet.books.isNotEmpty)
            _buildBibliographySection(context),
        ],
      ),
    );
  }

  Widget _buildInstructorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            S.of(context).instructors,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        if (courseUnitSheet.professors.length <= 4)
          Wrap(
            spacing: _instructorSpacing,
            runSpacing: _instructorRunSpacing,
            children: courseUnitSheet.professors
                .map((instructor) => _InstructorCard(instructor: instructor))
                .toList(),
          )
        else
          AnimatedExpandable(
            firstChild:
                _LimitedInstructorsRow(instructors: courseUnitSheet.professors),
            secondChild:
                _InstructorsRow(instructors: courseUnitSheet.professors),
          ),
        _addDivider(),
      ],
    );
  }

  Widget _buildExamsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            S.of(context).assessments,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        if (exams.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              S.of(context).noExamsScheduled,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: exams.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: _instructorSpacing),
              itemBuilder: (context, index) => SizedBox(
                width: 240,
                child: ExamCard(
                  name: exams[index].subject,
                  acronym: exams[index].subjectAcronym,
                  rooms: exams[index].rooms,
                  type: exams[index].examType,
                  startTime: exams[index].startTime,
                  examDay: exams[index].start.day.toString(),
                  examMonth: exams[index]
                      .monthAcronym(PreferencesController.getLocale()),
                  showIcon: false,
                ),
              ),
            ),
          ),
        _addDivider(),
      ],
    );
  }

  Widget _buildContentCard(
    String sectionTitle,
    String sectionContent,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          GenericExpandable(
            title: sectionTitle,
            content: HtmlWidget(
              sectionContent != 'null' ? sectionContent : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          _addDivider(),
        ],
      ),
    );
  }

  Widget _buildBibliographySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).bibliography,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: courseUnitSheet.books
              .map((book) => _buildBookTile(context, book))
              .toList(),
        ),
      ],
    );
  }

  Widget _addDivider() {
    return const Opacity(
      opacity: 0.25,
      child: Divider(color: Colors.grey),
    );
  }

  Widget _buildBookTile(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          SizedBox(
            width: _bookCardWidth,
            height: _bookCardHeight,
            child: book.isbn.isNotEmpty
                ? FutureBuilder<String?>(
                    future: BookThumbFetcher().fetchBookThumb(book.isbn),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Image(image: NetworkImage(snapshot.data!));
                      } else {
                        return const Image(
                          image: AssetImage(
                            'assets/images/book_placeholder.png',
                          ),
                        );
                      }
                    },
                  )
                : const Image(
                    image: AssetImage(
                      'assets/images/book_placeholder.png',
                    ),
                  ),
          ),
          SizedBox(
            width: _bookCardWidth,
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  const _InstructorCard({required this.instructor});

  final Professor instructor;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    return FutureBuilder<File?>(
      future: ProfileProvider.fetchOrGetCachedProfilePicture(
        session,
        studentNumber: int.parse(instructor.code),
      ),
      builder: (context, snapshot) {
        final profileImage = snapshot.hasData && snapshot.data != null
            ? FileImage(snapshot.data!)
            : null;

        return InstructorCard(
          name: instructor.name,
          isRegent: instructor.isRegent,
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => ProfessorInfoModal(instructor),
          ),
          instructorLabel: S.of(context).instructor,
          regentLabel: S.of(context).courseRegent,
          profileImage: profileImage,
        );
      },
    );
  }
}

class _LimitedInstructorsRow extends StatelessWidget {
  const _LimitedInstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context) {
    final firstThree = instructors.take(3).toList();
    final remaining = instructors.skip(3).toList();
    final remainingToShow = remaining.take(3).toList();
    final session = context.read<SessionProvider>().state!;

    return Wrap(
      spacing: _instructorSpacing,
      runSpacing: _instructorRunSpacing,
      children: [
        ...firstThree
            .map((instructor) => _InstructorCard(instructor: instructor)),
        if (remaining.isNotEmpty)
          FutureBuilder<List<File?>>(
            future: Future.wait(
              remainingToShow.map(
                (instructor) => ProfileProvider.fetchOrGetCachedProfilePicture(
                  session,
                  studentNumber: int.parse(instructor.code),
                ),
              ),
            ),
            builder: (context, snapshot) {
              final images = snapshot.data
                      ?.map((file) => file != null
                          ? FileImage(file) as ImageProvider
                          : null)
                      .toList() ??
                  List.filled(remainingToShow.length, null);

              return RemainingInstructorsCard(
                remainingCount: remaining.length,
                remainingInstructorsLabel:
                    S.of(context).moreInstructors(remaining.length),
                profileImages: images,
              );
            },
          ),
      ],
    );
  }
}

class _InstructorsRow extends StatelessWidget {
  const _InstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _instructorSpacing,
      runSpacing: _instructorRunSpacing,
      children: instructors
          .map((instructor) => _InstructorCard(instructor: instructor))
          .toList(),
    );
  }
}

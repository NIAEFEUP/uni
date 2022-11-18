import 'package:flutter/material.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

/// Manages the courses info (course name, atual year, state and year of
/// first enrolment) on the user personal page.
class CourseInfoCard extends GenericCard {
  CourseInfoCard({Key? key, required this.course}) : super(key: key);

  final Course course;

  @override
  Widget buildCardContent(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Text('Ano curricular atual: ',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 20.0),
              child: getInfoText(course.currYear ?? 'Indisponível', context),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child: Text('Estado atual: ',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
              child: getInfoText(course.state ?? 'Indisponível', context),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child: Text('Ano da primeira inscrição: ',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
                margin:
                    const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
                child: getInfoText(
                    course.firstEnrollment != null
                        ? '${course.firstEnrollment}/${course.firstEnrollment! + 1}'
                        : '?',
                    context))
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child: Text('Faculdade: ',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
                margin:
                    const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
                child: getInfoText(
                    course.faculty?.toUpperCase() ?? 'Indisponível', context))
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child:
                  Text('Média: ', style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
                margin:
                    const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
                child: getInfoText(
                    course.currentAverage?.toString() ?? 'Indisponível',
                    context))
          ]),
          TableRow(children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 20.0),
              child: Text('ECTs realizados: ',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
                margin:
                    const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 20.0),
                child: getInfoText(
                    course.finishedEcts?.toString().replaceFirst('.0', '') ??
                        '?',
                    context))
          ])
        ]);
  }

  @override
  String getTitle() {
    return course.name ?? 'Curso sem nome';
  }

  @override
  onClick(BuildContext context) {}
}

import 'package:flutter/material.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

/// Manages the courses info (course name, atual year, state and year of
/// first enrolment) on the user personal page.
class CourseInfoCard extends GenericCard {
  CourseInfoCard({super.key, required this.course});

  final Course course;

  @override
  Widget buildCardContent(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 8, left: 20),
              child: Text('Ano curricular atual: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
              margin:
              const EdgeInsets.only(top: 20, bottom: 8, right: 20),
              child: getInfoText(course.currYear ?? 'Indisponível', context),
            )
          ],),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 20),
              child: Text('Estado atual: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
              margin:
              const EdgeInsets.only(top: 10, bottom: 8, right: 20),
              child: getInfoText(course.state ?? 'Indisponível', context),
            )
          ],),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 20),
              child: Text('Ano da primeira inscrição: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
                margin:
                const EdgeInsets.only(top: 10, bottom: 8, right: 20),
                child: getInfoText(
                    course.firstEnrollment != null
                        ? '${course.firstEnrollment}/${course.firstEnrollment! +
                        1}'
                        : '?',
                    context,),)
          ],),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 20),
              child: Text('Faculdade: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
                margin:
                const EdgeInsets.only(top: 10, bottom: 8, right: 20),
                child: getInfoText(
                    course.faculty?.toUpperCase() ?? 'Indisponível', context,),)
          ],),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 20),
              child: Text('Média: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
                margin:
                const EdgeInsets.only(top: 10, bottom: 8, right: 20),
                child: getInfoText(
                    course.currentAverage?.toString() ?? 'Indisponível',
                    context,),)
          ],),
          TableRow(children: [
            Container(
              margin:
              const EdgeInsets.only(top: 10, bottom: 20, left: 20),
              child: Text('ECTs realizados: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,),
            ),
            Container(
                margin:
                const EdgeInsets.only(top: 10, bottom: 20, right: 20),
                child: getInfoText(
                    course.finishedEcts?.toString().replaceFirst('.0', '') ??
                        '?',
                    context,),)
          ],)
        ],);
  }

  @override
  String getTitle() {
    return course.name ?? 'Curso sem nome';
  }

  @override
  onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {}
}

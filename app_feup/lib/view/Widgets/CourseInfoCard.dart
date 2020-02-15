import 'package:app_feup/model/entities/Course.dart';
import 'package:flutter/material.dart';

import 'GenericCard.dart';

class CourseInfoCard extends GenericCard {

  CourseInfoCard({Key key, this.course, this.courseState});

  final Course course;
  final String courseState;

  @override
  Widget buildCardContent(BuildContext context) {
    return Table(
        columnWidths: {1: FractionColumnWidth(.4)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Text("Ano curricular atual: ",
                  style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4)
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
              child: getInfoText(course.currYear, context),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child: Text("Estado atual: ",
                  style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4)
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
              child: getInfoText(courseState, context),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 20.0),
              child: Text("Ano da primeira inscrição: ",
                  style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4)
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 25.0),
                child: getInfoText(course.firstEnrollment.toString() + "/" + (course.firstEnrollment+1).toString(), context)
            )
          ]),
        ]
    );
  }

  @override
  String getTitle() {
    return course.name;
  }

  @override
  onClick(BuildContext context) {}

}
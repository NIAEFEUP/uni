import 'package:app_feup/model/entities/Profile.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';

import 'GenericCard.dart';

class CourseInfoCard extends GenericCard {

  CourseInfoCard({Key key, this.course, this.courseState});

  Course course;
  String courseState;

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
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                  child: Text(course.currYear,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      )
                  ),
                )
              ]),
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
                  child: Text("Estado atual: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 30.0),
                  child: Text(courseState,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      )
                  ),
                )
              ]),
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 20.0),
                  child: Text("Ano da primeira inscrição: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 30.0),
                  child: Text(course.firstEnrollment.toString() + "/" + (course.firstEnrollment+1).toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      )
                  ),
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
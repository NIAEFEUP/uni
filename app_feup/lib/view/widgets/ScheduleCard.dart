import 'package:app_feup/view/Theme.dart';

import '../../controller/parsers/parser-schedule.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Lecture firstLecture;
  final Lecture secondLecture;
  final double borderRadius = 12.0;
  final double leftPadding = 12.0;

  ScheduleCard(
      {Key key, @required this.firstLecture, @required this.secondLecture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Center(
            child: new Container(
              padding: EdgeInsets.only(left: 8.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        child: Text(firstLecture.startTime,
                            style: Theme.of(context).textTheme.body2.apply(color: greyTextColor)),
                        margin: EdgeInsets.only(top: 8.0, bottom: 12.0),
                      ),
                      new Container(
                        child: Text(firstLecture.endTime,
                            style: Theme.of(context).textTheme.body2.apply(color: greyTextColor)),
                        margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
                      ),
                    ],
                  ),

                  new Expanded(child: new Container(
                    margin: EdgeInsets.only(left: 24.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: new Text(
                            firstLecture.subject,
                            style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor, fontWeightDelta: 2),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(top: 14.0, bottom: 12.0),
                              child: new Text(
                                firstLecture.teacher,
                                style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 14.0, bottom: 12.0),
                              child: new Text(
                                firstLecture.room,
                                style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            )),

        new Center(
            child: new Container(
              padding: EdgeInsets.only(left: 8.0, top: 12.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        child: Text(secondLecture.startTime,
                            style: Theme.of(context).textTheme.body2.apply(color: greyTextColor)),
                        margin: EdgeInsets.only(top: 8.0, bottom: 12.0),
                      ),
                      new Container(
                        child: Text(secondLecture.endTime,
                            style: Theme.of(context).textTheme.body2.apply(color: greyTextColor)),
                        margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
                      ),
                    ],
                  ),

                  new Expanded(child: new Container(
                    margin: EdgeInsets.only(left: 24.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: new Text(
                            secondLecture.subject,
                            style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor, fontWeightDelta: 2),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(top: 14.0, bottom: 12.0),
                              child: new Text(
                                secondLecture.teacher,
                                style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 14.0, bottom: 12.0),
                              child: new Text(
                                secondLecture.room,
                                style: Theme.of(context).textTheme.body2.apply(color: whiteTextColor),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            )),

      ],
    ));
  }
}

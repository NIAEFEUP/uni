import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/row_container.dart';

class ClassRegistrationScheduleTile extends StatelessWidget {
  final String subject;
  final String rooms;
  final String begin;
  final String end;
  final String teacher;
  final String typeClass;
  final String classNumber;
  final bool hasDiscontinuity;

  ClassRegistrationScheduleTile({
    Key key,
    @required this.subject,
    @required this.typeClass,
    @required this.rooms,
    @required this.begin,
    @required this.end,
    this.teacher,
    this.classNumber,
    this.hasDiscontinuity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
          top: hasDiscontinuity
              ? BorderSide(
                  color: Theme.of(context).dividerColor,
                )
              : BorderSide.none,
        ),
      ),
      padding: EdgeInsets.all(10),
      key: Key('schedule-slot-time-${this.begin}-${this.end}'),
      margin: EdgeInsets.only(left: 18.0),
      child: createScheduleTileInfo(context),
    );
  }

  Widget createScheduleTileInfo(context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            this.begin + " - " + this.end,
            key: Key('schedule-slot-time-${this.begin}-${this.end}'),
            overflow: TextOverflow.ellipsis,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  this.subject,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .apply(fontSizeDelta: 5),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' (' + this.typeClass + ')',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(fontSizeDelta: -4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              this.classNumber,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .apply(fontSizeDelta: -4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              this.rooms,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .apply(fontSizeDelta: -4),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              this.teacher,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .apply(fontSizeDelta: -4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EstimatedArrivalTimeStamp extends StatelessWidget {
  final String timeRemaining;

  EstimatedArrivalTimeStamp({
    Key key,
    @required this.timeRemaining,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.content['timeStamp'],
      builder: (context, timeStamp){
        return this.getContent(context, timeStamp);
      },
    );
  }

  Widget getContent(BuildContext context, timeStamp) {
    DateTime estimatedTime = timeStamp.add(Duration(minutes: int.parse(timeRemaining), seconds: 30));

    int num = estimatedTime.hour;
    String hour = (num >= 10 ? '$num' : '0$num');
    num = estimatedTime.minute;
    String minute = (num >= 10 ? '$num' : '0$num');

    return new Text('$hour:$minute', style: Theme.of(context).textTheme.display1.apply(color: greyTextColor));
  }
}
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusStopTimeStampRow extends StatelessWidget{

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
    String hour;
    String minute;
    int num;

    num = timeStamp.hour;

    if(num < 10)
      hour = '0$num';
    else hour = '$num';

    num = timeStamp.minute;

    if(num < 10)
      minute = '0$num';
    else minute = '$num';

    return new Center(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children : [
          Text('Last refreshed at $hour:$minute',style: Theme.of(context).textTheme.display1.apply(color: black))
        ]
      ),
    );
  }

  int getTimeDifference(context, timeStamp) {
    DateTime now = new DateTime.now();

    int result = now.millisecondsSinceEpoch - timeStamp.millisecondsSinceEpoch;

    return (result/60000).floor();
  }

}
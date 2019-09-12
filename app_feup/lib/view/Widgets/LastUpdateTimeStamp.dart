import 'dart:async';

import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LastUpdateTimeStamp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LastUpdateState();
}

class _LastUpdateState extends  State<LastUpdateTimeStamp> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.content['timeStamp'],
      builder: (context, timeStamp){
        return new Container(
          padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
          child: this.getContent(context, timeStamp)
        );
      },
    );
  }

  Widget getContent(BuildContext context, timeStamp) {
    Duration last_update = now.difference(timeStamp);
    int last_update_minutes = last_update.inMinutes;

    return new Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children : [
          Text('Last refreshed $last_update_minutes minutes ago',style: Theme.of(context).textTheme.display1.apply(color: Colors.black))
        ]
    );
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 60), (Timer t) => _updateTime());
    super.initState();
  }

  void _updateTime(){
    setState(() {
      now = DateTime.now();
    });
  }
}
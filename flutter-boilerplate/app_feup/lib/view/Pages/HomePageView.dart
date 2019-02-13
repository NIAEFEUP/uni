import 'package:app_feup/view/widgets/GeneralCardWidget.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key,
    @required this.title,
    @required this.value,
    @required this.color,
    @required this.onChanged}) : super(key: key);

  final int value;
  final Function onChanged;
  final Color color;
  final String title;



  /*********** MAIN BUILD METHOD ***********/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      title: new Text(title),
      ),
//      body: createCounterDisplay(context),
        body: new GeneralCard( 
          title: 'Horario',
          child: Text('Meias e que sao do carago'),
        )
//      floatingActionButton: createActionButton(context),
    );
  }



//  Widget createActionButton(BuildContext context){
//    return new FloatingActionButton(
//      onPressed: () => onChanged(value+1),
//      tooltip: 'Increment',
//      child: new Icon(Icons.add),
//    );
//  }

//  Widget createCounterDisplay(BuildContext context){
//    return new Center(
//      child: new Container(
//        padding: EdgeInsets.all(16),
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new Text(
//              'You have pushed the button this many times:',
//              style: Theme.of(context).textTheme.body1,
//            ),
//            new Text(
//              '$value',
//              style: Theme.of(context).textTheme.title.apply(color: color),
//            ),
//          ],
//        ),
//      ) ,
//    );
//  }
}

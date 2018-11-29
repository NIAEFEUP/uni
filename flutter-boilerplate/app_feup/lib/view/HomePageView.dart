import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key key, this.value: 0, @required this.onChanged}) : super(key: key);

  final int value;
  final Function onChanged;

  @override
  _HomePageViewState createState() => new _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  void _incrementCounter() {
    widget.onChanged(widget.value+1);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('Counter'),
      ),
      body: createCounterDisplay(),
      floatingActionButton: createActionButton(),
    );
  }

  Widget createActionButton(){
    return new FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: new Icon(Icons.add),
    );
  }

  Widget createCounterDisplay(){
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'You have pushed the button this many times:',
          ),
          new Text(
            '${widget.value}',
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
    );
  }
}

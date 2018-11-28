import 'package:flutter/material.dart';

class ClickCounter extends StatefulWidget {
  ClickCounter(this._value, this._callback, {Key key}) : super(key: key);

  final int _value;
  final Function _callback;

  @override
  _ClickCounterState createState() => new _ClickCounterState();
}

class _ClickCounterState extends State<ClickCounter> {
  int _value;
  Function _callback;

  void _incrementCounter() {
    setState(() {
      _value++;
    });
    _callback(_value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('Counter'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_value',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

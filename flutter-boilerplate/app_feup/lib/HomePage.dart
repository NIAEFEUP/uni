import 'package:flutter/material.dart';
import 'view/HomePageView.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _timesClicked = 0;

  void _setClickedAmount(value) {
    setState(() {
      _timesClicked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new HomePageView(value: _timesClicked, onChanged: _setClickedAmount);
  }
}

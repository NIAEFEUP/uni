import 'package:app_feup/controller/counterSelectors.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();

  //Handle arguments from parent
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    //Here pass the state variables and callback functions needed for the view
    return new HomePageView(
        title: widget.title,
        value: _timesClicked,
        color: _numberColor,
        onChanged: _setClickedAmount);
  }

  /****************** STATE *********************/
  //These are the state variables for this widget

  int _timesClicked = 0;
  Color _numberColor = getColorFromValue(0);


  /**************** ACTIONS ********************/
  //dont put complex code inside the actions. Use methods from controller

  void _setClickedAmount(value) {
    setState(() {
      _timesClicked = value;
      _numberColor = getColorFromValue(value);
    });
  }
}

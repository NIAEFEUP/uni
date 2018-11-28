import 'package:flutter/material.dart';

// --READ--

// Stateful Widget are to be used only when
// you need to store some information not relevant
// to the application's overall state (in other words
// it only affects this widget and nothing else)

// If you need to save something to the application's
// state, you need to have a callback so the parent
// widget can


class SampleStatefulWidget extends StatefulWidget {
  @override
  SampleStatefulWidgetState createState() => SampleStatefulWidgetState();
}

class SampleStatefulWidgetState extends State<SampleStatefulWidget>{

  int someValue = 0;

  void functionToProcessAStateChange(){
    setState(() {
      //Here we set the new state
      someValue += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Here return the widget tree that represents this widget
  }

}
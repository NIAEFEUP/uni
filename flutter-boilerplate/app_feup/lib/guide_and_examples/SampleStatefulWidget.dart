import 'package:flutter/material.dart';

// --READ--

// Stateful Widget are to be used only when
// you need to store some information not relevant
// to the application's overall state (in other words
// it only affects this widget and nothing else)

// If you need to save something to the application's or page's
// state, you need to use callback functions until you
// reach that widget


class SampleStatefulWidget extends StatefulWidget {
  @override
  SampleStatefulWidgetState createState() => SampleStatefulWidgetState();
}

class SampleStatefulWidgetState extends State<SampleStatefulWidget>{

  int someValue = 0;

  //this is an action - it processes a state change
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
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
          title: 'Horário',
          child: Text("This\nis\na\nheight\ntest\nto\nknow\nif\nthe\ncard\nexpands")
        )
//      floatingActionButton: createActionButton(context),
    );
  }
}
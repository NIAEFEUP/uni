import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key,
    @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new GenericCard(
          title: 'Horário',
          child: Text("This\nis\na\nheight\ntest\nto\nknow\nif\nthe\ncard\nexpands")
        )
    );
  }
}
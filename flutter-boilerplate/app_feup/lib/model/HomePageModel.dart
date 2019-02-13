import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();

  //Handle arguments from parent
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
}

class _HomePageState extends State<HomePage> {

  final networkRouter = NetworkRouter();
  @override
  Widget build(BuildContext context) {
    //Here pass the state variables and callback functions needed for the view
    return new HomePageView(
        title: widget.title,
        onChanged: _login);
  }
  void _login(user, password) {
    networkRouter.login(user, password);
  }
}

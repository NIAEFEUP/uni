import 'package:flutter/material.dart';
import 'dart:async';
import '../../model/LoginPageModel.dart';
import '../../view/Theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), ()=> Navigator.pushReplacement(context, new MaterialPageRoute(builder: (__) => new LoginPage())));
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: applicationTheme.primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Center(
                  child: createTitle()
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(bottom: 50)),
                    createNILogo(),
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget createTitle(){
    return Text(
      "APP\nFEUP",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white, 
        fontSize: 50.0,
        fontWeight: FontWeight.w400
        ),
    );
  }

  Widget createNILogo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Powered by",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w200
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Image(
            image: AssetImage('assets/ni_logo.png'),
            width: 85.0,
            height: 85.0
          ),
        )
      ],
    );
  }
}

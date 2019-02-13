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
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "APP\nFEUP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 50.0,
                          fontWeight: FontWeight.w400
                          ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Expanded(
                      child: Row(
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
                      ),
                    )
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
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

  MediaQueryData queryData;

  @override
  Widget build(BuildContext context){
    queryData = MediaQuery.of(context);
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
              Padding(padding: EdgeInsets.only(bottom: queryData.size.height/4)),
              createTitle(),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(bottom: queryData.size.height/16)),
                  createNILogo(),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: queryData.size.height/10))
            ],
          )
        ],
      ),
    );
  }

  Widget createTitle() {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: queryData.size.width/8,
        minHeight: queryData.size.height/6,
      ),
      child: FittedBox(
        child: Text(
          "APP\nFEUP",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400),
        ),
        fit: BoxFit.fill
      )
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
            width: queryData.size.height/9,
            height: queryData.size.height/9
          ),
        )
      ],
    );
  }
}

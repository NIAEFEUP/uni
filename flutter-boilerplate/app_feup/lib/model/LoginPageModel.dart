import 'package:app_feup/view/Pages/LoginPageView.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();

  //Handle arguments from parent
  LoginPage({Key key}) : super(key: key);
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return new LoginPageView(
        saveData: _saveData,
        saveDataChanged: _changeSaveData,
        logInPressed: _logIn);
  }

  bool _saveData = false;
  
  void _changeSaveData(value){
    setState(() {
      _saveData = value;
    });
    //TODO: save data here
  }

  void _logIn(username, password) {
    //TODO: verify username and password here
    print(username);
    print(password);
  }
}

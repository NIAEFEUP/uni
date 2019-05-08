import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/pages/ProfilePageView.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();

  //Handle arguments from parent
  ProfilePage({Key key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  
  String name;
  String email;
  Map<String, String> currentState;
  String printBalance;
  String feesBalance;
  String nextFeeLimitData;
  List<Course> courses;

  @override
  void initState() {
    super.initState();
    name = "";
    email = "";
    currentState = {};
    printBalance = "";
    feesBalance = "";
    nextFeeLimitData = "";
    courses = [];
  }

  @override
  Widget build(BuildContext context) {
    updateInfo();
    return new ProfilePageView(
      name: name,
      email: email,
      currentState: currentState,
      printBalance: printBalance,
      feesBalance: feesBalance,
      nextFeeLimitData: nextFeeLimitData,
      courses: courses);
  }

  void updateInfo() {
    setState(() {
      if(StoreProvider.of<AppState>(context).state.content['profile'] != null) {
        name = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].name;
        email = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].email;
        currentState = StoreProvider
            .of<AppState>(context)
            .state
            .content['coursesStates'];
        courses = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].courses;
        printBalance = StoreProvider
            .of<AppState>(context)
            .state
            .content['printBalance'];
        feesBalance = StoreProvider
            .of<AppState>(context)
            .state
            .content['feesBalance'];
        nextFeeLimitData = StoreProvider
            .of<AppState>(context)
            .state
            .content['feesLimit'];
      }
    });
  }
}
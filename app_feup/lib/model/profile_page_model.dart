import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Pages/profile_page_view.dart';
import 'dart:io';

import 'entities/course.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

  //Handle arguments from parent
  ProfilePage({Key key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  String name;
  String email;
  Map<String, String> currentState;
  List<Course> courses;
  Future<File> profilePicFile;

  @override
  void initState() {
    super.initState();
    name = '';
    email = '';
    currentState = {};
    courses = [];
    profilePicFile = null;
  }

  @override
  Widget build(BuildContext context) {
    updateInfo();
    return ProfilePageView(
        name: name, email: email, currentState: currentState, courses: courses);
  }

  void updateInfo() async {
    setState(() {
      if (StoreProvider.of<AppState>(context).state.content['profile'] !=
          null) {
        name =
            StoreProvider.of<AppState>(context).state.content['profile'].name;
        email =
            StoreProvider.of<AppState>(context).state.content['profile'].email;
        currentState =
            StoreProvider.of<AppState>(context).state.content['coursesStates'];
        courses = StoreProvider.of<AppState>(context)
            .state
            .content['profile']
            .courses;
      }
    });
  }
}

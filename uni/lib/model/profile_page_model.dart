import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Pages/Profile/profile.dart';
import 'package:uni/model/entities/course.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();

  //Handle arguments from parent
  const ProfilePage({Key? key}) : super(key: key);
}

class ProfilePageState extends State<ProfilePage> {
  late String name;
  late String email;
  late Map<String, String> currentState;
  late List<Course> courses;
  Future<File>? profilePicFile;

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

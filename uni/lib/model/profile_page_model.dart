import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/Pages/profile_page_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();

  const ProfilePage({Key? key}) : super(key: key);
}

class ProfilePageState extends State<ProfilePage> {
  late String name;
  late String email;
  late List<Course> courses;
  Future<File>? profilePicFile;

  @override
  void initState() {
    super.initState();
    name = '';
    email = '';
    courses = [];
    profilePicFile = null;
  }

  @override
  Widget build(BuildContext context) {
    updateInfo();
    return ProfilePageView(name: name, email: email, courses: courses);
  }

  void updateInfo() async {
    setState(() {
      if (StoreProvider.of<AppState>(context).state.content['profile'] !=
          null) {
        name =
            StoreProvider.of<AppState>(context).state.content['profile'].name;
        email =
            StoreProvider.of<AppState>(context).state.content['profile'].email;
        courses = StoreProvider.of<AppState>(context)
            .state
            .content['profile']
            .courses;
      }
    });
  }
}

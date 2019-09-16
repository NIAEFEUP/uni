import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/ProfilePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:io';
import 'package:app_feup/controller/local_storage/ImageOfflineStorage.dart';

import 'entities/Course.dart';

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
  List<Course> courses;
  Future<DecorationImage> profilePicFile;

  @override
  void initState() {
    super.initState();
    name = "";
    email = "";
    currentState = {};
    courses = [];
    profilePicFile = null;

  }

  @override
  Widget build(BuildContext context) {
    profilePicFile = this.buildDecorageImage(context);
    updateInfo();
    return FutureBuilder(future: profilePicFile,
    builder: (BuildContext context,
    AsyncSnapshot<DecorationImage> decorationImage){
      return new ProfilePageView(
          name: name,
          email: email,
          currentState: currentState,
          courses: courses, profilePicFile: decorationImage.data);
    });

  }

  Future<DecorationImage> buildDecorageImage(context) async {

    String studentNo = StoreProvider.of<AppState>(context)
        .state
        .content['session']
        .studentNumber ??
        "";

    if (studentNo != "") {
      var x = await getProfileImage(context);
      return DecorationImage(fit: BoxFit.cover, image: FileImage(x));
    } else
      return null;
  }

  Future<File> getProfileImage(BuildContext context) {
    String studentNo = StoreProvider.of<AppState>(context)
        .state
        .content['session']
        .studentNumber;
    String url =
        "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=" +
            studentNo;

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] =
        StoreProvider.of<AppState>(context).state.content['session'].cookies;

    return retrieveImage(url, headers);
  }

  void updateInfo() async{
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
      }
    });
  }
}
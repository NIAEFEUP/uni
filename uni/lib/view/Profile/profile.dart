import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/Profile/widgets/account_info_card.dart';
import 'package:uni/view/Profile/widgets/print_info_card.dart';
import 'package:uni/view/Profile/widgets/course_info_card.dart';
import 'package:uni/view/Common/PagesLayouts/Secondary/secondary.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
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
  Widget build(BuildContext context){
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

class ProfilePageView extends StatefulWidget {
  final String name;
  final String email;
  final Map<String, String> currentState;
  final List<Course> courses;
  const ProfilePageView(
      {Key? key,
      required this.name,
      required this.email,
      required this.currentState,
      required this.courses})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return ListView(shrinkWrap: false, children: childrenList(context));
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  /// Returns a list with all the children widgets of this page.
  List<Widget> childrenList(BuildContext context) {
    final List<Widget> list = [];
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    list.add(profileInfo(context));
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    for (var i = 0; i < widget.courses.length; i++) {
      list.add(CourseInfoCard(
          course: widget.courses[i],
          courseState: widget.currentState[widget.courses[i].name] ?? '?'));
      list.add(const Padding(padding: EdgeInsets.all(5.0)));
    }
    list.add(PrintInfoCard());
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    list.add(AccountInfoCard());
    return list;
  }

  /// Returns a widget with the user's profile info (Picture, name and email).
  Widget profileInfo(BuildContext context) {
    return StoreConnector<AppState, Future<File?>?>(
      converter: (store) => loadProfilePic(store),
      builder: (context, profilePicFile) => FutureBuilder(
        future: profilePicFile,
        builder: (BuildContext context, AsyncSnapshot<File?> profilePic) =>
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: getDecorageImage(profilePic.data))),
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(widget.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w400)),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text(widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}

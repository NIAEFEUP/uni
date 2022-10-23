import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/profile/widgets/account_info_card.dart';
import 'package:uni/view/profile/widgets/course_info_card.dart';
import 'package:uni/view/profile/widgets/print_info_card.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return Consumer<ProfileStateProvider>(
      builder: (context, profileStateProvider, _) {
        final profile = profileStateProvider.profile;
        return ListView(
            shrinkWrap: false, children: childrenList(context, profile));
      },
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  /// Returns a list with all the children widgets of this page.
  List<Widget> childrenList(BuildContext context, Profile profile) {
    final List<Widget> list = [];
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    list.add(profileInfo(context, profile));
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    for (var i = 0; i < profile.courses.length; i++) {
      list.add(CourseInfoCard(course: profile.courses[i]));
      list.add(const Padding(padding: EdgeInsets.all(5.0)));
    }
    list.add(PrintInfoCard());
    list.add(const Padding(padding: EdgeInsets.all(5.0)));
    list.add(AccountInfoCard());
    return list;
  }

  /// Returns a widget with the user's profile info (Picture, name and email).
  Widget profileInfo(BuildContext context, Profile profile) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, _) {
        return FutureBuilder(
          future: loadProfilePicture(sessionProvider.session),
          builder: (BuildContext context, AsyncSnapshot<File?> profilePic) =>
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: getProfileDecorationImage(profilePic.data))),
              const Padding(padding: EdgeInsets.all(8.0)),
              Text(profile.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w400)),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text(profile.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w300)),
            ],
          ),
        );
      },
    );
  }
}

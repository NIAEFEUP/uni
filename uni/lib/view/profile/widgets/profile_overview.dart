import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({
    required this.profile,
    required this.getProfileDecorationImage,
    super.key,
  });
  final Profile profile;
  final DecorationImage Function(File?) getProfileDecorationImage;

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, _) {
        return FutureBuilder(
          future: ProfileProvider.fetchOrGetCachedProfilePicture(
            sessionProvider.session,
          ),
          builder: (BuildContext context, AsyncSnapshot<File?> profilePic) =>
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: profilePic.data != null
                      ? getProfileDecorationImage(profilePic.data)
                      : null,
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Text(
                profile.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

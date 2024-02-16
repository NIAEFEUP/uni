import 'package:flutter/material.dart';
import 'package:uni/model/entities/profile.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({
    required this.profile,
    required this.profileDecorationImage,
    super.key,
  });

  final Profile profile;
  final DecorationImage profileDecorationImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: 'profilePicture',
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: profileDecorationImage,
            ),
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
    );
  }
}

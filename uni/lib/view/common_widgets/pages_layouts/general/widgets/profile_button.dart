import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/utils/navigation_items.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({required this.getProfileDecorationImage, super.key});

  final DecorationImage Function(File?) getProfileDecorationImage;

  Future<DecorationImage> buildProfileDecorationImage(
    BuildContext context, {
    bool forceRetrieval = false,
  }) async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    await sessionProvider.ensureInitialized(context);
    final profilePictureFile =
        await ProfileProvider.fetchOrGetCachedProfilePicture(
      sessionProvider.state!,
      forceRetrieval: forceRetrieval,
    );
    return getProfileDecorationImage(profilePictureFile);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildProfileDecorationImage(context),
      builder: (
        BuildContext context,
        AsyncSnapshot<DecorationImage> decorationImage,
      ) {
        return TextButton(
          onPressed: () => {
            Navigator.pushNamed(
              context,
              '/${NavigationItem.navProfile.route}',
            ),
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: decorationImage.data,
            ),
          ),
        );
      },
    );
  }
}

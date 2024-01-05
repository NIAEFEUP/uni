import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/profile/profile.dart';

class TopRightButton extends StatelessWidget {
  const TopRightButton({required this.getProfileDecorationImage, super.key});

  final DecorationImage Function(File?) getProfileDecorationImage;

  Future<DecorationImage> buildProfileDecorationImage(
    BuildContext context, {
    bool forceRetrieval = false,
  }) async {
    final profilePictureFile =
        await ProfileProvider.fetchOrGetCachedProfilePicture(
      Provider.of<SessionProvider>(context, listen: false).state!,
      forceRetrieval:
          forceRetrieval || GeneralPageViewState.profileImageProvider == null,
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
            Navigator.push(
              context,
              MaterialPageRoute<ProfilePageView>(
                builder: (__) => const ProfilePageView(),
              ),
            ),
          },
          child: Container(
            width: 40,
            height: 40,
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

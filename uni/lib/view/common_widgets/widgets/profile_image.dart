import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    required this.radius,
    super.key,
  });

  final double radius;

  Future<DecorationImage?> buildProfileDecorationImage(
    BuildContext context,
  ) async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    await sessionProvider.ensureInitialized(context);
    final profilePictureFile =
        await ProfileProvider.fetchOrGetCachedProfilePicture(
      sessionProvider.state!,
    );
    return getProfileDecorationImage(profilePictureFile);
  }

  /// Returns the current user image.
  ///
  /// If the image is not found / doesn't exist returns null.
  DecorationImage? getProfileDecorationImage(File? profilePicture) {
    if (profilePicture == null) {
      return null;
    }

    return DecorationImage(
      fit: BoxFit.cover,
      image: FileImage(profilePicture),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildProfileDecorationImage(context),
      builder: (
        BuildContext context,
        AsyncSnapshot<DecorationImage?> decorationImage,
      ) {
        return CircleAvatar(
          radius: radius,
          foregroundImage: decorationImage.data?.image,
          // backgroundImage:
          //     const AssetImage('assets/images/profile_placeholder.png'),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}

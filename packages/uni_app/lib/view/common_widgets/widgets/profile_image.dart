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
    final image = profilePicture != null
        ? FileImage(profilePicture) as ImageProvider<Object>
        : const AssetImage('assets/images/profile_placeholder.png');

    return DecorationImage(
      fit: BoxFit.cover,
      image: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildProfileDecorationImage(context),
      builder: (context, decorationImage) {
        return CircleAvatar(
          radius: radius,
          foregroundImage: decorationImage.data?.image,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}

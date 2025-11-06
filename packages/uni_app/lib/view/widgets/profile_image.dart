import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni_ui/common_widgets/circle_avatar.dart';

class ProfileImage extends ConsumerWidget {
  const ProfileImage({required this.radius, super.key});

  final double radius;

  Future<DecorationImage?> buildProfileDecorationImage(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final session = await ref.read(sessionProvider.future);

    final profilePictureFile =
        await ProfileNotifier.fetchOrGetCachedProfilePicture(session!);
    return getProfileDecorationImage(profilePictureFile);
  }

  /// Returns the current user image.
  ///
  /// If the image is not found / doesn't exist returns null.
  DecorationImage? getProfileDecorationImage(File? profilePicture) {
    final image =
        profilePicture != null
            ? FileImage(profilePicture) as ImageProvider<Object>
            : const AssetImage('assets/images/profile_placeholder.png');

    return DecorationImage(fit: BoxFit.cover, image: image);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: buildProfileDecorationImage(context, ref),
      builder: (context, decorationImage) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: decorationImage.data?.image,
        );
      },
    );
  }
}

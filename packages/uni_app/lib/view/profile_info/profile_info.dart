import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/view/profile_info/widgets/profile_data.dart';
import 'package:uni/view/profile_info/widgets/profile_overview.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class ProfileInfoPageView extends ConsumerStatefulWidget {
  const ProfileInfoPageView({super.key});

  @override
  ConsumerState<ProfileInfoPageView> createState() => ProfileInfoPageViewState();
}

/// Manages the 'about' section of the app.
class ProfileInfoPageViewState extends SecondaryPageViewState<ProfileInfoPageView> {
  @override
  
  Widget getBody(BuildContext context) {
    return DefaultConsumer<Profile>(
      provider: profileProvider,
      builder: (context, ref, profile) => ListView(
        children: [
          ProfileOverview(profile: profile),
          ProfileData(profile: profile)
        ],
      ),
      hasContent: (profile) => profile.courses.isNotEmpty,
      nullContentWidget: Container(),
    );
  }

  @override
  Future<void> onRefresh() async {}

  @override
  String? getTitle() {
    return null;
  }
}

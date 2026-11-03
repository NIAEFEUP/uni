import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/profile_info.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_info_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/view/profile/profile_shimmer.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';
import 'package:uni/view/profile_info/widgets/no_profile_data.dart';
import 'package:uni/view/profile_info/widgets/profile_data.dart';
import 'package:uni/view/profile_info/widgets/profile_info_shimmer.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class ProfileInfoPageView extends ConsumerStatefulWidget {
  const ProfileInfoPageView({super.key});

  @override
  ConsumerState<ProfileInfoPageView> createState() =>
      ProfileInfoPageViewState();
}

/// Manages the profile information page of the app.
class ProfileInfoPageViewState
    extends SecondaryPageViewState<ProfileInfoPageView> {
  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        DefaultConsumer<Profile>(
          provider: profileProvider,
          builder: (context, ref, profile) => ProfileOverview(profile: profile),
          hasContent: (profile) => true,
          nullContentWidget: LayoutBuilder(
            // Band-aid for allowing refresh on null content
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: constraints.maxHeight,
                padding: const EdgeInsets.only(bottom: 120),
                child: const Center(child: NoProfileDataWidget()),
              ),
            ),
          ),
          loadingWidget: const ProfileCardShimmer(),
        ),

        DefaultConsumer<ProfileInfo>(
          provider: profileInfoProvider,
          builder: (context, ref, profileInfo) =>
              ProfileData(profileInfo: profileInfo),
          hasContent: (profileInfo) =>
              true, // because profileInfo != null is allways true
          nullContentWidget: const Center(child: NoProfileDataWidget()),
          loadingWidget: const ShimmerProfileInfoPage(),
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh() async {
    await Future.wait([
      ref.read(profileProvider.notifier).refreshRemote(),
      ref.read(profileInfoProvider.notifier).refreshRemote(),
    ]);
  }

  @override
  String? getTitle() {
    return null;
  }
}

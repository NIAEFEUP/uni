import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/view/profile/profile_shimmer.dart';
import 'package:uni/view/profile/widgets/profile_info.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';
import 'package:uni/view/profile/widgets/settings.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class ProfilePageView extends ConsumerStatefulWidget {
  const ProfilePageView({super.key});

  @override
  ConsumerState<ProfilePageView> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        DefaultConsumer<Profile>(
          provider: profileProvider,
          builder: (context, ref, profile) => Column(
            children: [
              ProfileOverview(profile: profile),
              const ProfileInfoWidget(),
            ],
          ),
          hasContent: (profile) => profile.courses.isNotEmpty,
          loadingWidget: const ProfileCardShimmer(),
          nullContentWidget: Container(),
        ),
        const Settings(),
      ],
    );
  }

  @override
  Future<void> onRefresh() async {
    await ref.read(profileProvider.notifier).refreshRemote();
  }

  @override
  String? getTitle() {
    return null;
  }
}

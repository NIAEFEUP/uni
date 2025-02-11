import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/profile_info.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';
import 'package:uni/view/profile/widgets/settings.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) {
        return ListView(
          children: [
            ProfileOverview(profile: profile),
            const ProfileInfo(),
            const Settings(),
          ],
        );
      },
      hasContent: (profile) => profile.courses.isNotEmpty,
      onNullContent: Container(),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<ProfileProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  String? getTitle() {
    return null;
  }
}

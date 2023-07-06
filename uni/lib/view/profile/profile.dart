import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/account_info_card.dart';
import 'package:uni/view/profile/widgets/course_info_card.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<ProfileStateProvider>(
      builder: (context, profileStateProvider, _) {
        final profile = profileStateProvider.profile;
        final List<Widget> courseWidgets = profile.courses
            .map((e) => [
                  CourseInfoCard(course: e),
                  const Padding(padding: EdgeInsets.all(5.0))
                ])
            .flattened
            .toList();

        return ListView(shrinkWrap: false, children: [
          const Padding(padding: EdgeInsets.all(5.0)),
          ProfileOverview(
              profile: profile,
              getProfileDecorationImage: getProfileDecorationImage),
          const Padding(padding: EdgeInsets.all(5.0)),
          // PrintInfoCard() // TODO: Bring this back when print info is ready again
          ...courseWidgets,
          AccountInfoCard(),
        ]);
      },
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }
}

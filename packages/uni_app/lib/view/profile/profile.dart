import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/account_info_card.dart';
import 'package:uni/view/profile/widgets/course_info_card.dart';
import 'package:uni/view/profile/widgets/print_info_card.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';

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
        final courseWidgets = profile.courses
            .map(
              (e) => [
                CourseInfoCard(course: e),
                const Padding(padding: EdgeInsets.all(5)),
              ],
            )
            .flattened
            .toList();

        return ListView(
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            const Padding(padding: EdgeInsets.all(10)),
            ProfileOverview(profile: profile),
            const Padding(padding: EdgeInsets.all(5)),
            ...courseWidgets,
            AccountInfoCard(),
            const Padding(padding: EdgeInsets.all(5)),
            PrintInfoCard(),
          ],
        );
      },
      hasContent: (profile) => profile.courses.isNotEmpty,
      onNullContent: Container(),
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => Navigator.pushNamed(
        context,
        '/${NavigationItem.navSettings.route}',
      ),
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

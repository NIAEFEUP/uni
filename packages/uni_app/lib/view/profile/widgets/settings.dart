import 'package:flutter/material.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/about.dart';
import 'package:uni/view/bug_report/bug_report.dart';
import 'package:uni/view/profile/widgets/locale_switch_button.dart';
import 'package:uni/view/profile/widgets/notifications_dialog.dart';
import 'package:uni/view/profile/widgets/theme_switch_button.dart';
import 'package:uni/view/profile/widgets/usage_stats_switch.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          GenericCard(
            tooltip: S.of(context).settings,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ProfileListTile(
                  icon: UniIcons.pallete,
                  title: S.of(context).theme,
                  trailing: const ThemeSwitchButton(),
                ),
                ProfileListTile(
                  icon: UniIcons.globeHemisphereWest,
                  title: S.of(context).language,
                  trailing: const LocaleSwitchButton(),
                ),
                ProfileListTile(
                  icon: UniIcons.chartBar,
                  title: S.of(context).collect_usage_stats,
                  trailing: const UsageStatsSwitch(),
                ),
                ProfileListTile(
                  icon: UniIcons.notification,
                  title: S.of(context).notifications,
                  onTap: () {
                      showDialog<NotificationsDialog>(
                        context: context,
                        builder: (context) => const NotificationsDialog(),
                      );
                    },
                ),
              ],
            ),
          ),
          GenericCard(
            tooltip: S.of(context).leave_feedback,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ProfileListTile(
              icon: UniIcons.thumbsUp,
              title: S.of(context).leave_feedback,
              subtitle: S.of(context).feedback_description,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<BugReportPageView>(
                    builder: (context) => const BugReportPageView(),
                  ),
                );
              },
            ),
          ),
          GenericCard(
            tooltip: S.of(context).terms,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ProfileListTile(
              icon: UniIcons.gavel,
              title: S.of(context).terms,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<AboutPageView>(
                    builder: (context) => const AboutPageView(),
                  ),
                );
              },
            ),
          ),
          GenericCard(
            tooltip: S.of(context).logout,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ProfileListTile(
              icon: UniIcons.signOut,
              title: S.of(context).logout,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: NetworkRouter.authenticationController?.close,
            ),
          ),
        ],
      ),
    );
  }
}

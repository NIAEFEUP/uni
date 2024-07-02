import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/about.dart';
import 'package:uni/view/bug_report/bug_report.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/settings/widgets/locale_switch_button.dart';
import 'package:uni/view/settings/widgets/logout_confirm_dialog.dart';
import 'package:uni/view/settings/widgets/notifications_dialog.dart';
import 'package:uni/view/settings/widgets/theme_switch_button.dart';
import 'package:uni/view/settings/widgets/usage_stats_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends SecondaryPageViewState<SettingsPage> {
  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 50)),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                ListTile(
                  title: Text(S.of(context).language),
                  trailing: const LocaleSwitchButton(),
                ),
                ListTile(
                  title: Text(S.of(context).theme),
                  trailing: const ThemeSwitchButton(),
                ),
                ListTile(
                  title: Text(S.of(context).collect_usage_stats),
                  trailing: const UsageStatsSwitch(),
                ),
                ListTile(
                  title: Text(S.of(context).notifications),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog<NotificationsDialog>(
                      context: context,
                      builder: (context) => const NotificationsDialog(),
                    );
                  },
                ),
                ListTile(
                  title: Text(S.of(context).report_error_suggestion),
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
                ListTile(
                  title: Text(S.of(context).about),
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
                ListTile(
                  title: Text(S.of(context).logout),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => showDialog<LogoutConfirmDialog>(
                    context: context,
                    builder: (context) => const LogoutConfirmDialog(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}

  @override
  String? getTitle() => S.of(context).settings;
}

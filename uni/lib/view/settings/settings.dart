import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

import 'package:uni/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends GeneralPageViewState<SettingsPage> {
  @override
  Future<void> onRefresh(BuildContext context) async {}

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        PageTitle(name: "defs"),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Language'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/language');
                },
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/theme');
                },
              ),
              ListTile(
                title: const Text('About'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/about');
                },
              ),
            ],
          ),
        )),
      ],
    );
  }
}

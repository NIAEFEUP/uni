import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/enabled_feature_controller.dart';

import 'package:uni/generated/l10n.dart';
import 'package:uni/view/settings/widgets/feature_flags/library_modules_switch.dart';

class FeatureFlagsDialog extends StatefulWidget {
  const FeatureFlagsDialog({super.key});

  @override
  FeatureFlagsDialogState createState() => FeatureFlagsDialogState();
}

class FeatureFlagsDialogState extends State<FeatureFlagsDialog> {
  late Future<SharedPreferences> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).feature_flags),
      content: FutureBuilder<SharedPreferences>(
        future: _preferences,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final enabledFeatureController =
              EnabledFeatureController(snapshot.data!);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Library modules'),
                trailing: LibraryModulesSwitch(
                  enabledFeatureController: enabledFeatureController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

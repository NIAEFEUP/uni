import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/enabled_feature_controller.dart';

class ExperimentalFeatureWrapper extends StatefulWidget {
  const ExperimentalFeatureWrapper({
    required this.featureCode,
    required this.child,
    super.key,
  });

  final String featureCode;
  final Widget child;

  @override
  State<StatefulWidget> createState() => ExperimentalFeatureWrapperState();
}

class ExperimentalFeatureWrapperState
    extends State<ExperimentalFeatureWrapper> {
  late Future<SharedPreferences> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _preferences,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final enabledFeatureController =
            EnabledFeatureController(snapshot.data!);
        return enabledFeatureController.existsFeature(widget.featureCode)
            ? widget.child
            : Container();
      },
    );
  }
}

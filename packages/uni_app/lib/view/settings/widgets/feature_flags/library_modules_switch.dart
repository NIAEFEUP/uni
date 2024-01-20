import 'package:uni/view/settings/widgets/feature_flags/feature_switch.dart';

class LibraryModulesSwitch extends FeatureSwitch {
  const LibraryModulesSwitch({
    required super.enabledFeatureController,
    super.key,
  });

  @override
  FeatureSwitchState<FeatureSwitch> createState() =>
      LibraryModulesSwitchState();
}

class LibraryModulesSwitchState
    extends FeatureSwitchState<LibraryModulesSwitch> {
  static const String _featureCode = 'library_modules';

  @override
  bool initializeValue() {
    return widget.enabledFeatureController.existsFeature(_featureCode);
  }

  @override
  Future<void> storeValue({required bool value}) async {
    if (value) {
      await widget.enabledFeatureController.addFeature(_featureCode);
    } else {
      await widget.enabledFeatureController.removeFeature(_featureCode);
    }
  }
}

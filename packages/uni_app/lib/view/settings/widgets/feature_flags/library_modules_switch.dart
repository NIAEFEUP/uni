import 'package:uni/controller/local_storage/enabled_feature_controller.dart';
import 'package:uni/view/settings/widgets/generic_switch.dart';

class LibraryModulesSwitch extends GenericSwitch {
  const LibraryModulesSwitch({
    required this.enabledFeatureController,
    super.key,
  });

  final EnabledFeatureController enabledFeatureController;

  @override
  GenericSwitchState<GenericSwitch> createState() =>
      LibraryModulesSwitchState();
}

class LibraryModulesSwitchState
    extends GenericSwitchState<LibraryModulesSwitch> {
  @override
  bool initializeValue() {
    return widget.enabledFeatureController.existsFeature('library_cards');
  }

  @override
  Future<void> storeValue({required bool value}) async {
    await widget.enabledFeatureController.addFeature('library_cards');
  }
}

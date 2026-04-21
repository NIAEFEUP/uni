import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

final pedagogicalSurveysProvider = StateProvider<bool>((ref) {
  return PreferencesController.shouldShowPedagogicalSurveysDialog();
});

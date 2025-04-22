import 'package:uni/controller/local_storage/preferences_controller.dart';

class Migrations {
  static Future<void> migrateToV2() async {
    await PreferencesController.setDefaultCards();
  }
}

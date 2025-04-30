import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/migrations/migrations.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class MigrationController {
  static const int currentPreferencesVersion = 3;

  static Future<void> runMigrations() async {
    final storedVersion = PreferencesController.getPreferencesVersion();

    for (var version = storedVersion;
        version < currentPreferencesVersion;
        version++) {
      await runMigration(version);
    }

    await PreferencesController.setPreferencesVersion(
      currentPreferencesVersion,
    );
  }

  static Future<void> runMigration(int version) async {
    switch (version) {
      case 1:
        Logger().d('Migrating Shared Preferences Version (1 -> 2)');
        await Migrations.migrateToV2();
      case 2:
        Logger().d('Migrating Shared Preferences Version (2 -> 3)');
        await Migrations.migrateToV3();
      default:
        Logger().d('No migration found');
    }
  }
}

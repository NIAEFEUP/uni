import 'package:uni/controller/local_storage/preferences_controller.dart';

class Migrations {
  static Future<void> migrateToV2() async {
    // on version 1 we were storing each favorite card by its index in FavoriteWidgetType.
    // from version 1 to version 2, we deleted some cards (e.g., buses)
    // this means that when a user updates from 1 -> 2, if they had one of those deleted cards, the app crashes as it tries to find that deleted card
    // we could try and filter the user's favorite cards, which is quite impossible because we were storing indexes before and now we are storing strings
    // the easiest solution is to reset only this preference to the default one, which is not that bad as the homepage is fresh new
    await PreferencesController.setDefaultCards();
  }
}

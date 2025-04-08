import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class Migrations {
  static Future<void> migrateToV2() async {
    final oldCards = PreferencesController.getFavoriteCards();

    if (oldCards.isNotEmpty) {
      final validCards = oldCards.where((card) {
        return FavoriteWidgetType.values.any((type) => type == card);
      }).toList();

      await PreferencesController.saveFavoriteCards(validCards);
    }
  }
}

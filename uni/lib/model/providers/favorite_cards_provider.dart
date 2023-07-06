import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class FavoriteCardsProvider extends StateProviderNotifier {
  List<FavoriteWidgetType> _favoriteCards = [];

  List<FavoriteWidgetType> get favoriteCards {
    ensureInitialized();
    return _favoriteCards.toList();
  }

  @override
  loadFromRemote() async {
    setFavoriteCards(await AppSharedPreferences.getFavoriteCards());
  }

  setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

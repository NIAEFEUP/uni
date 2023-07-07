import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class FavoriteCardsProvider extends StateProviderNotifier {
  List<FavoriteWidgetType> _favoriteCards = [];

  List<FavoriteWidgetType> get favoriteCards => _favoriteCards.toList();

  @override
  loadFromStorage() async {
    setFavoriteCards(await AppSharedPreferences.getFavoriteCards());
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {}

  setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

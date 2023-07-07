import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class HomePageProvider extends StateProviderNotifier {
  List<FavoriteWidgetType> _favoriteCards = [];
  bool _isEditing = false;

  List<FavoriteWidgetType> get favoriteCards => _favoriteCards.toList();
  bool get isEditing => _isEditing;

  @override
  Future<void> loadFromStorage() async {
    setFavoriteCards(await AppSharedPreferences.getFavoriteCards());
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {}

  setHomePageEditingMode(bool state) {
    _isEditing = state;
    notifyListeners();
  }

  toggleHomePageEditingMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

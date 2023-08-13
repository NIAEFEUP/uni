import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class HomePageProvider extends StateProviderNotifier {
  HomePageProvider() : super(dependsOnSession: false, cacheDuration: null);
  List<FavoriteWidgetType> _favoriteCards = [];
  bool _isEditing = false;

  List<FavoriteWidgetType> get favoriteCards => _favoriteCards.toList();

  bool get isEditing => _isEditing;

  @override
  Future<void> loadFromStorage() async {
    setFavoriteCards(await AppSharedPreferences.getFavoriteCards());
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    updateStatus(RequestStatus.successful);
  }

  void setHomePageEditingMode({required bool editingMode}) {
    _isEditing = editingMode;
    notifyListeners();
  }

  void toggleHomePageEditingMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

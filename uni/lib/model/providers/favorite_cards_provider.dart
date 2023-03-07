import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class FavoriteCardsProvider extends StateProviderNotifier {
  List<FavoriteWidgetType> _favoriteCards = [];

  List<FavoriteWidgetType> get favoriteCards => _favoriteCards.toList();

  setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

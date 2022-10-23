import 'dart:collection';

import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class FavoriteCardsProvider extends StateProviderNotifier {
  List<FavoriteWidgetType> _favoriteCards = [];

  UnmodifiableListView<FavoriteWidgetType> get favoriteCards =>
      UnmodifiableListView(_favoriteCards);

  setFavoriteCards(List<FavoriteWidgetType> favoriteCards) {
    _favoriteCards = favoriteCards;
    notifyListeners();
  }
}

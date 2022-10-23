import 'package:uni/model/providers/state_provider_notifier.dart';

class HomePageEditingMode extends StateProviderNotifier {
  bool _state = false;

  bool get state => _state;

  setHomePageEditingMode(bool state) {
    _state = state;
    notifyListeners();
  }
}

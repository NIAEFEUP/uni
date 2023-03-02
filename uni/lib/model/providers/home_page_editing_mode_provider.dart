import 'package:uni/model/providers/state_provider_notifier.dart';

class HomePageEditingModeProvider extends StateProviderNotifier {
  bool _isEditing = false;

  bool get state => _isEditing;

  setHomePageEditingMode(bool state) {
    _isEditing = state;
    notifyListeners();
  }

  toggle() {
    _isEditing = !_isEditing;
    notifyListeners();
  }
}

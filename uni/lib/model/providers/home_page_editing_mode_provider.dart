import 'package:uni/model/providers/state_provider_notifier.dart';

class HomePageEditingModeProvider extends StateProviderNotifier {
  bool _isEditing = false;

  bool get isEditing => _isEditing;

  @override
  void loadFromStorage() {}

  setHomePageEditingMode(bool state) {
    _isEditing = state;
    notifyListeners();
  }

  toggle() {
    _isEditing = !_isEditing;
    notifyListeners();
  }
}

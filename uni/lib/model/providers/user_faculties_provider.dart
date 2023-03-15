import 'dart:collection';

import 'package:uni/model/providers/state_provider_notifier.dart';

class UserFacultiesProvider extends StateProviderNotifier{
  List<String> _faculties = [];

  UnmodifiableListView<String> get faculties => UnmodifiableListView(_faculties);

  setUserFaculties(List<String> faculties){
    _faculties = faculties;
    notifyListeners();
  }
}
import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

final selectedAccountFacultyProvider =
    StateNotifierProvider<SelectedAccountFacultyNotifier, String?>(
      (ref) => SelectedAccountFacultyNotifier(
        PreferencesController.getSelectedAccountFaculty(),
      ),
    );

class SelectedAccountFacultyNotifier extends StateNotifier<String?> {
  SelectedAccountFacultyNotifier(super.initialFaculty);

  void setFaculty(String? faculty) {
    state = faculty;
    PreferencesController.setSelectedAccountFaculty(faculty);
  }
}

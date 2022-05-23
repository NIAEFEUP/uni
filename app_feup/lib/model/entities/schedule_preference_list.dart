import 'package:uni/model/entities/schedule_option.dart';

import '../class_registration_model.dart';

class SchedulePreferenceList {
  List<ScheduleOption> preferences;
  Semester semester;

  SchedulePreferenceList(this.semester, this.preferences);

  int get length => preferences.length;
  ScheduleOption operator [](int index) => preferences[index];

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final ScheduleOption item = preferences.removeAt(oldIndex);
    preferences.insert(newIndex, item);
  }

  void remove(int index) {
    this.preferences.removeAt(index);
  }

  void add(ScheduleOption option) {
    this.preferences.add(option);
  }
}

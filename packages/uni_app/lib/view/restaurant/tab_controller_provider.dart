import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/utils/day_of_week.dart';

final tabControllerProvider = StateNotifierProvider<TabControllerProvider, int>(
  (ref) => TabControllerProvider(),
);

class TabControllerProvider extends StateNotifier<int> {
  TabControllerProvider() : super(DateTime.now().weekday - 1);

  void setTabIndex(int index) {
    if (index >= 0 && index < DayOfWeek.values.length) {
      state = index;
    }
  }

  void nextTab() {
    if (state < DayOfWeek.values.length - 1) {
      state = state + 1;
    }
  }

  void previousTab() {
    if (state > 0) {
      state = state - 1;
    }
  }
}

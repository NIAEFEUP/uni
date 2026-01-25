import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';

final tabControllerProvider = StateNotifierProvider<TabControllerProvider, int>(
  (ref) => TabControllerProvider(),
);

class TabControllerProvider extends StateNotifier<int> {
  TabControllerProvider() : super(_getInitialIndex());

  static int _getInitialIndex() {
    final now = DateTime.now();

    int index = now.weekday - 1;

    if (RestaurantUtils.isAfterSwitchHour(now)) {
      index++;
    }

    if (index >= DayOfWeek.values.length) {
      index = 0;
    }

    return index;
  }

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

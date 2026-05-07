import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:uni/model/entities/lecture.dart';

class WidgetService {
  /// iOS
  static const iOSWidgetAppGroupId = 'group.uniApp';
  static const iOSWidgetName = 'ScheduleWidget';

  /// Android
  static const androidPackagePrefix = 'pt.up.fe.ni.uni';
  static const androidWidgetName =
      '$androidPackagePrefix.receivers.ScheduleWidgetReceiver';
  static const androidWidgetWideName =
      '$androidPackagePrefix.receivers.ScheduleWidgetWideReceiver';

  /// Called in main.dart
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(iOSWidgetAppGroupId);
  }

  /// Update the schedule widget with the next lecture
  static Future<void> updateScheduleWidget(List<dynamic> scheduleData) async {
    final jsonData = jsonEncode(scheduleData);
    await _saveData('schedule_data', jsonData);

    await _updateWidget(
      iOSWidgetName: iOSWidgetName,
      qualifiedAndroidName: androidWidgetName,
    );

    await _updateWidget(
      qualifiedAndroidName: androidWidgetWideName,
    );
  }

  /// Save data to Shared Preferences
  static Future<void> _saveData<T>(String key, T data) async {
    await HomeWidget.saveWidgetData<T>(key, data);
  }

  /// Retrieve data from Shared Preferences
  static Future<T?> _getData<T>(String key) async {
    return await HomeWidget.getWidgetData<T>(key);
  }

  /// Request to update widgets on both iOS and Android
  static Future<void> _updateWidget({
    String? iOSWidgetName,
    String? qualifiedAndroidName,
  }) async {
    final result = await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      qualifiedAndroidName: qualifiedAndroidName,
    );
    debugPrint(
      '[WidgetService.updateWidget] iOSWidgetName: $iOSWidgetName, qualifiedAndroidName: $qualifiedAndroidName, result: $result',
    );
  }
}

extension on Iterable<Lecture> {
  List<Lecture> sortedBy(Comparable Function(Lecture l) selector) {
    final list = toList();
    list.sort((a, b) => selector(a).compareTo(selector(b)));
    return list;
  }
}

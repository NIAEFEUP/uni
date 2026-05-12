import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  /// iOS
  static const iOSWidgetAppGroupId = 'group.pt.up.fe.ni.uni';
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

  static Future<void> updateScheduleWidget(List<dynamic> scheduleData) async {
    final jsonData = jsonEncode(scheduleData);
    await HomeWidget.saveWidgetData('schedule_data', jsonData);

    await HomeWidget.updateWidget(
      iOSName: 'ScheduleWidget',
      qualifiedAndroidName: androidWidgetName,
    );
  }
}

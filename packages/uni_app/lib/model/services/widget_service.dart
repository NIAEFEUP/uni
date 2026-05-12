import 'dart:convert';
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

  static Future<void> updateScheduleWidget(List<dynamic> scheduleData) async {
    final jsonData = jsonEncode(scheduleData);
    await HomeWidget.saveWidgetData('schedule_data', jsonData);

    await HomeWidget.updateWidget(
      iOSName: 'ScheduleWidget',
      qualifiedAndroidName: androidWidgetName,
    );
  }
}

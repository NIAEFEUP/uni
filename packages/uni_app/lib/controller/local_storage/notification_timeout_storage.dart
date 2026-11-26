import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class NotificationTimeoutStorage {
  NotificationTimeoutStorage._create();

  late Map<String, dynamic> _fileContent;

  Future<void> _asyncInit() async {
    _fileContent = _readContentsFile(await _getTimeoutFile());
  }

  static Future<NotificationTimeoutStorage> create() async {
    final notificationStorage = NotificationTimeoutStorage._create();
    await notificationStorage._asyncInit();
    return notificationStorage;
  }

  Map<String, dynamic> _readContentsFile(File file) {
    try {
      return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    } on FormatException catch (_) {
      return <String, dynamic>{};
    }
  }

  DateTime getLastTimeNotificationExecuted(String uniqueID) {
    if (!_fileContent.containsKey(uniqueID)) {
      return DateTime.fromMicrosecondsSinceEpoch(
        0,
      ); // get 1970 to always trigger notification
    }
    return DateTime.parse(_fileContent[uniqueID] as String);
  }

  Future<void> addLastTimeNotificationExecuted(
    String uniqueID,
    DateTime lastRan,
  ) async {
    _fileContent[uniqueID] = lastRan.toIso8601String();
    await _writeToFile(await _getTimeoutFile());
  }

  /// Returns when [uniqueID] last fired, or `null` if it never did.
  /// Only notifications with a time-to-live write this.
  DateTime? getLastTimeNotificationFired(String uniqueID) {
    final value = _fileContent[_firedAtKey(uniqueID)];
    if (value is! String) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  Future<void> setLastTimeNotificationFired(
    String uniqueID,
    DateTime firedAt,
  ) async {
    _fileContent[_firedAtKey(uniqueID)] = firedAt.toIso8601String();
    await _writeToFile(await _getTimeoutFile());
  }

  Future<void> clearLastTimeNotificationFired(String uniqueID) async {
    if (_fileContent.remove(_firedAtKey(uniqueID)) != null) {
      await _writeToFile(await _getTimeoutFile());
    }
  }

  String _firedAtKey(String uniqueID) => '${uniqueID}_firedAt';

  Future<void> _writeToFile(File file) async {
    await file.writeAsString(jsonEncode(_fileContent));
  }

  Future<File> _getTimeoutFile() async {
    final applicationDirectory =
        (await getApplicationDocumentsDirectory()).path;
    if (!File('$applicationDirectory/notificationTimeout.json').existsSync()) {
      // empty json
      await File(
        '$applicationDirectory/notificationTimeout.json',
      ).writeAsString('{}');
    }
    return File('$applicationDirectory/notificationTimeout.json');
  }
}

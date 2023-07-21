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
      return jsonDecode(file.readAsStringSync());
    } on FormatException catch (_) {
      return <String, dynamic>{};
    }
  }

  DateTime getLastTimeNotificationExecuted(String uniqueID) {
    if (!_fileContent.containsKey(uniqueID)) {
      return DateTime.fromMicrosecondsSinceEpoch(
          0); //get 1970 to always trigger notification
    }
    return DateTime.parse(_fileContent[uniqueID]);
  }

  Future<void> addLastTimeNotificationExecuted(
      String uniqueID, DateTime lastRan) async {
    _fileContent[uniqueID] = lastRan.toIso8601String();
    await _writeToFile(await _getTimeoutFile());
  }

  Future<void> _writeToFile(File file) async {
    await file.writeAsString(jsonEncode(_fileContent));
  }

  Future<File> _getTimeoutFile() async {
    final applicationDirectory =
        (await getApplicationDocumentsDirectory()).path;
    if (!(await File('$applicationDirectory/notificationTimeout.json')
        .exists())) {
      //empty json
      await File('$applicationDirectory/notificationTimeout.json')
          .writeAsString('{}');
    }
    return File('$applicationDirectory/notificationTimeout.json');
  }
}

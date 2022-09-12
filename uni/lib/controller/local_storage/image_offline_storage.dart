import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uni/controller/networking/network_router.dart';

/// The offline image storage location on the device.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Gets cached image named [localFileName].
/// If not found or too old, downloads it from [url] with [headers].
Future<File?> loadImageFromStorageOrRetrieveNew(
    String localFileName, String url, Map<String, String> headers,
    {int staleDays = 7}) async {
  final path = await _localPath;
  final targetPath = '$path/$localFileName';
  final File file = File(targetPath);

  if (file.existsSync() &&
      file
          .lastModifiedSync()
          .add(Duration(days: staleDays))
          .isAfter(DateTime.now())) {
    return file;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  final hasInternetConnection = connectivityResult != ConnectivityResult.none;
  if (hasInternetConnection) {
    return _downloadAndSaveImage(targetPath, url, headers);
  }
  return null;
}

/// Downloads the image located at [url] and saves it in [filePath].
Future<File?> _downloadAndSaveImage(
    String filePath, String url, Map<String, String> headers) async {
  final response = await http.get(url.toUri(), headers: headers);
  if (response.statusCode == 200) {
    return File(filePath).writeAsBytes(response.bodyBytes);
  }
  return null;
}

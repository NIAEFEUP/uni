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
Future<File?> loadFileFromStorageOrRetrieveNew(
    String localFileName, String url, Map<String, String> headers,
    {int staleDays = 7, forceRetrieval = false}) async {
  final path = await _localPath;
  final targetPath = '$path/$localFileName';
  final File file = File(targetPath);

  final bool fileExists = file.existsSync();
  final bool fileIsStale = forceRetrieval ||
      (fileExists &&
          file
              .lastModifiedSync()
              .add(Duration(days: staleDays))
              .isBefore(DateTime.now()));
  if (fileExists && !fileIsStale) {
    return file;
  }
  if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
    final File? downloadedFile =
        await _downloadAndSaveFile(targetPath, url, headers);
    if (downloadedFile != null) {
      return downloadedFile;
    }
  }
  return fileExists ? file : null;
}

/// Downloads the image located at [url] and saves it in [filePath].
Future<File?> _downloadAndSaveFile(
    String filePath, String url, Map<String, String> headers) async {
  final response = await http.get(url.toUri(), headers: headers);
  if (response.statusCode == 200) {
    return File(filePath).writeAsBytes(response.bodyBytes);
  }
  return null;
}

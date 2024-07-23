import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

/// The offline image storage location on the device.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Gets cached image named [localFileName].
/// If not found or too old, downloads it from [url].
/// The headers are retrieved from [session], then [headers] if provided.
Future<File?> loadFileFromStorageOrRetrieveNew(
  String localFileName,
  String url,
  Session? session, {
  Map<String, String>? headers,
  int staleDays = 7,
  bool forceRetrieval = false,
}) async {
  final path = await _localPath;
  final targetPath = '$path/$localFileName';
  final file = File(targetPath);

  final fileExists = file.existsSync();
  final fileIsStale = forceRetrieval ||
      (fileExists &&
          file
              .lastModifiedSync()
              .add(Duration(days: staleDays))
              .isBefore(DateTime.now()));

  if (fileExists && !fileIsStale) {
    return file;
  }

  if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
    final downloadedFile =
        await _downloadAndSaveFile(targetPath, url, session, headers);
    if (downloadedFile != null) {
      Logger().d('Downloaded $localFileName from remote');
      return downloadedFile;
    }
  }

  if (fileExists) {
    Logger().d('Loaded stale $localFileName from local storage');
    return file;
  }

  Logger().w('Failed to load $localFileName');
  return null;
}

/// Downloads the image located at [url] and saves it in [filePath].
Future<File?> _downloadAndSaveFile(
  String filePath,
  String url,
  Session? session,
  Map<String, String>? headers,
) async {
  final header = headers ?? <String, String>{};

  final response = session == null
      ? await http.get(url.toUri(), headers: headers)
      : await NetworkRouter.getWithCookies(url, header, session);

  if (response.statusCode == 200) {
    return File(filePath).writeAsBytes(response.bodyBytes);
  }

  return null;
}

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show DefaultCacheManager;
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

/// The offline image storage location on the device.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Gets cached image named [localFileName].
/// If not found or too old, downloads it from [url] with [headers].
Future<File?> loadImageFromCacheOrGetAndCache(
    String localFileName, String url, Map<String, String> headers) async {
  final path = await _localPath;
  final targetPath = '$path/$localFileName';
  final File file = File(targetPath);

  if (file.existsSync()) {
    return file;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  final hasInternetConnection = connectivityResult != ConnectivityResult.none;
  if (hasInternetConnection && headers.isNotEmpty) {
    return _downloadAndSaveImage(targetPath, url, headers);
  }
  return null;
}

/// Downloads the image located at [url] and saves it in [filepath], if it is old enough;
/// otherwise, the cached version will be returned.
Future<File?> _downloadAndSaveImage(
    String filepath, String url, Map<String, String> headers) async {
  try {
    final File file = await DefaultCacheManager()
        .getSingleFile(url, headers: headers, key: filepath);
    final Image? image = decodeImage(await file.readAsBytes());
    if (image != null) {
      File(filepath).writeAsBytes(encodePng(image));
      return file;
    }
    return null;
  } catch (e) {
    return null;
  }
}

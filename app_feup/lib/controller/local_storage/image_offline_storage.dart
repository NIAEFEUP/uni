import 'dart:async';
import 'dart:io';
import 'package:image/image.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show DefaultCacheManager;
import 'package:path_provider/path_provider.dart';

/// The offline image storage location on the device.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Downloads an image located at the given [url].
/// The image is accessed with the provided [headers], if they are present.
Future<File> getImageFromNetwork(
    String url, Map<String, String> headers) async {
  return DefaultCacheManager().getSingleFile(url, headers: headers);
}

/// Downloads and caches the user's profile image located at [url]. The image
/// is accessed with the provided [headers], if they are present.
///
/// If no connectivity is available, the cached version is used instead.
/// If there is no cached version, returns [null].
Future<File> retrieveImage(String url, Map<String, String> headers) async {
  final path = await _localPath;
  final connectivityResult = await (Connectivity().checkConnectivity());
  final hasInternetConnection = connectivityResult != ConnectivityResult.none;

  final targetPath = '$path/profile_pic.png';
  final File file = File(targetPath);

  if (hasInternetConnection && headers.isNotEmpty) {
    return saveImage(targetPath, url, headers);
  } else if (file.existsSync()) {
    return file;
  } else {
    return null;
  }
}

/// Downloads the image located at [url] and saves it in [filepath]. The image
/// is accessed with the provided [headers], if they are present.
Future<File> saveImage(
    String filepath, String url, Map<String, String> headers) async {
  final File file = await getImageFromNetwork(url, headers);
  final Image image = decodeImage(await file.readAsBytes());
  File(filepath)..writeAsBytes(encodePng(image));
  return file;
}

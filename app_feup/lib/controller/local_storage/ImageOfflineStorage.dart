import 'dart:async';
import 'dart:io';
import 'package:image/image.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getImageFromNetwork(String url,  Map<String, String> headers) async {
  File file = await DefaultCacheManager().getSingleFile(url, headers: headers);
  return file;
}

Future<File> retrieveImage(String url, Map<String, String> headers) async {
  final path = await _localPath;
  final connectivityResult = await (Connectivity().checkConnectivity());
  final hasInternetConnection = connectivityResult != ConnectivityResult.none;

  final targetPath = '$path/profile_pic.png';
  final File file  = new File(targetPath);
  if(hasInternetConnection && headers.isNotEmpty){
    return saveImage(targetPath, url, headers);
  }
  else if(file.existsSync()) {
    return file;
  } else
    return null;
}

Future<File> saveImage(String filepath, String url, Map<String, String> headers) async {

  final file = await getImageFromNetwork(url, headers);
  final Image image = decodeImage(file.readAsBytesSync());

  return new File(filepath)
    ..writeAsBytesSync(encodePng(image));
}
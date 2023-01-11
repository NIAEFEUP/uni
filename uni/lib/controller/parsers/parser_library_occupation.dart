import 'dart:convert';

import 'package:http/http.dart';
import 'package:uni/model/entities/library_occupation.dart';

Future<LibraryOccupation> parseLibraryOccupationFromSheets(
    Response response) async {
  final json = response.body.split('\n')[1]; // ignore first line
  const toSkip =
      'google.visualization.Query.setResponse('; // this content should be ignored
  const numFloors = 6;
  const List<int> max = [61, 105, 105, 105, 40, 64];
  final LibraryOccupation occupation = LibraryOccupation(0, 0);

  final jsonDecoded =
      jsonDecode(json.substring(toSkip.length, json.length - 2));

  for (int i = 0; i < numFloors; i++) {
    int floor;
    try {
      floor = jsonDecoded["table"]["rows"][i]["c"][8]["v"].toInt();
      occupation.addFloor(FloorOccupation(i + 1, floor, max[i]));
    } catch (e) {
      occupation.addFloor(FloorOccupation(i + 1, 0, 0));
    }
  }

  return occupation;
}

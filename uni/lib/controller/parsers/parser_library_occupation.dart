import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/library_occupation.dart';

Future<LibraryOccupation> parseLibraryOccupationFromSheets(
    Response response) async {
  final js = response.body.split('\n')[1];
  const skip = 'google.visualization.Query.setResponse(';
  const num_floors = 6;
  const List<int> max = [69, 105, 105, 105, 40, 64];
  LibraryOccupation occupation = LibraryOccupation(0, 0);

  final json = jsonDecode(js.substring(skip.length, js.length - 2));

  for (int i = 0; i < num_floors; i++) {
    int floor = json["table"]["rows"][i]["c"][8]["v"].toInt();
    occupation.addFloor(FloorOccupation(i + 1, floor, max[i]));
  }

  return occupation;
}

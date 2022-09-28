import 'package:gsheets/gsheets.dart';
import 'package:uni/model/entities/library_occupation.dart';

Future<LibraryOccupation> getLibraryOccupationFromSheet(Worksheet sheet) async {
  try {
    final occupation = LibraryOccupation(0, 0);

    for (int i = 1; i < 7; i++) {
      final occupationCell = await sheet.cells.cell(column: 3, row: i + 1);
      final capacityCell = await sheet.cells.cell(column: 5, row: i + 1);

      occupation.addFloor(FloorOccupation(
          i, int.parse(occupationCell.value), int.parse(capacityCell.value)));
    }
    return occupation;
  } catch (FormatException) {
    return LibraryOccupation(0, 0);
  }
}
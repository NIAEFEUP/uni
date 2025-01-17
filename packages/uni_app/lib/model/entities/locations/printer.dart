import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class Printer implements Location {
  Printer(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.printer;

  final int? locationGroupId;

  @override
  String description() {
    return 'Impressora';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.printer)};
  }
}

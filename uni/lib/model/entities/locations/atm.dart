import 'package:uni/model/entities/location.dart';
import 'package:uni/view/locations/widgets/icons.dart';

class Atm implements Location {

  Atm(this.floor, {this.locationGroupId}) : super();
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = LocationIcons.cashMultiple;

  final int? locationGroupId;

  @override
  String description() {
    return 'Atm';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.atm)};
  }
}

import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class CarPark implements Location {
  CarPark(this.floor, this.name, {this.locationGroupId});
  @override
  final int floor;
  final String name;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.carPark;

  final int? locationGroupId;

  @override
  String description() {
    return name;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'name': name,  'type': locationTypeToString(LocationType.carPark)};
  }
}

import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class CarPark implements Location {
  CarPark(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.carPark;

  final int? locationGroupId;

  @override
  String description() {
    return 'car park';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.carPark)};
  }
}

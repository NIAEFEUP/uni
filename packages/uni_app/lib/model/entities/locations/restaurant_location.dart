import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class RestaurantLocation implements Location {
  RestaurantLocation(this.floor, this.name, {this.locationGroupId});
  @override
  final int floor;

  @override
  final int weight = 4;

  final String name;

  @override
  final icon = UniIcons.restaurant;

  final int? locationGroupId;

  @override
  String description() {
    return name;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.restaurant),
      'name': name,
    };
  }
}

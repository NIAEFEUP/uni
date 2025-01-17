import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class WcLocation implements Location {
  WcLocation(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.toilet;

  final int? locationGroupId;

  @override
  String description() {
    return 'Casa de banho';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.atm)};
  }
}

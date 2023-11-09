import 'package:uni/model/entities/location.dart';
import 'package:uni/view/locations/widgets/icons.dart';

class VendingMachine implements Location {
  VendingMachine(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = LocationIcons.bottleSodaClassic;

  final int? locationGroupId;

  @override
  String description() {
    return 'Máquina de venda';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.vendingMachine),
    };
  }
}

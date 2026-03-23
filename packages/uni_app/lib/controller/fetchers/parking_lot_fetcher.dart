import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/parking_lot_occupation.dart';
import 'package:uni/session/flows/base/session.dart';

class ParkingLotFetcher {
  static const _endpoint = 'instalacs_geral.ocupacao_parques';

  Future<ParkingLotOccupation> getParkingLotOccupation(Session session) async {
    final url = '${NetworkRouter.getBaseUrl('feup')}$_endpoint';

    final response = await NetworkRouter.getWithCookies(url, {}, session);
    return _parse(response.body);
  }

  ParkingLotOccupation _parse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final itdc = json['itdc'] as List<dynamic>;
    final resposta =
        (itdc.first as Map<String, dynamic>)['resposta']
            as Map<String, dynamic>;

    final lots = [
      ParkingLot(
        id: 'P1',
        type: ParkingLotType.permanentStaff,
        capacity: resposta['p1lotacao'] as int,
        occupied: resposta['p1ocupados'] as int,
        free: resposta['p1livres'] as int,
      ),
      ParkingLot(
        id: 'P3',
        type: ParkingLotType.students,
        capacity: resposta['p3lotacao'] as int,
        occupied: resposta['p3ocupados'] as int,
        free: resposta['p3livres'] as int,
      ),
      ParkingLot(
        id: 'P4',
        type: ParkingLotType.nonPermanentStaff,
        capacity: resposta['p4lotacao'] as int,
        occupied: resposta['p4ocupados'] as int,
        free: resposta['p4livres'] as int,
      ),
    ];

    return ParkingLotOccupation(lots);
  }
}

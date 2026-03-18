import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';

class IndoorFloorLayer extends StatelessWidget {
  const IndoorFloorLayer({
    required this.floorPlans,
    required this.selectedFloor,
    super.key,
  });

  final List<IndoorFloorPlan> floorPlans;
  final int? selectedFloor;

  @override
  Widget build(BuildContext context) {
    if (selectedFloor == null) {
      return const SizedBox.shrink();
    }

    // Filter floor plans for selected floor
    final currentFloorPlans = floorPlans
        .where((plan) => plan.floor == selectedFloor)
        .toList();

    if (currentFloorPlans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Rooms layer
        PolygonLayer(
          polygons: currentFloorPlans
              .expand(
                (plan) => plan.rooms.map(
                  (room) => Polygon(
                    points: room.polygon,
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                    label: room.ref,
                    labelStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Corridors layer
        PolygonLayer(
          polygons: currentFloorPlans
              .expand(
                (plan) => plan.corridors.map(
                  (corridor) => Polygon(
                    points: corridor.polygon,
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderColor: Colors.grey,
                    borderStrokeWidth: 1,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

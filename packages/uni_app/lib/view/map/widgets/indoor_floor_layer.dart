import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';

class IndoorFloorLayer extends StatelessWidget {
  const IndoorFloorLayer({
    required this.floorPlans,
    required this.selectedFloor,
    this.roomFilter,
    this.hasSearchContent = false,
    super.key,
  });

  final List<IndoorFloorPlan> floorPlans;
  final int? selectedFloor;
  final bool Function(IndoorRoom room)? roomFilter;
  final bool hasSearchContent;

  @override
  Widget build(BuildContext context) {
    if (selectedFloor == null) {
      return const SizedBox.shrink();
    }

    final camera = MapCamera.of(context);
    if (camera.zoom < 17.8 && !hasSearchContent) {
      return const SizedBox.shrink();
    }

    // Filter floor plans for selected floor
    final currentFloorPlans = floorPlans
        .where((plan) => plan.floor == selectedFloor)
        .toList();
    final visibleRooms = currentFloorPlans
        .expand((plan) => plan.rooms)
        .where((room) => roomFilter?.call(room) ?? true)
        .toList();

    if (currentFloorPlans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Rooms layer
        PolygonLayer(
          polygons: visibleRooms
              .map(
                (room) => Polygon(
                  points: room.polygon,
                  color: Theme.of(context).colorScheme.secondary,
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderStrokeWidth: 2,
                  label: room.ref,
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
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

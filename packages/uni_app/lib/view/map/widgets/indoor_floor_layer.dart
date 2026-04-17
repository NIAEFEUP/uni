import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/view/map/helpers/room_label_info.dart';

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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                    borderColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderStrokeWidth: 1,
                  ),
                ),
              )
              .toList(),
        ),
        // Labels layer
        MarkerLayer(
          markers: visibleRooms.map((room) {
            final labelProps = getRoomLabelInfo(
              room.polygon,
              room.ref,
              camera.zoom,
            );

            return Marker(
              point: labelProps.center,
              width: 100,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: labelProps.angle,
                child: Center(
                  child: Text(
                    room.ref,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: labelProps.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

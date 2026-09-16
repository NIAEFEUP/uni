import 'package:flutter/services.dart' show rootBundle;
import 'package:uni/controller/fetchers/campus/locations/location_fetcher.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location_group.dart';

class LocationFetcherAsset extends LocationFetcher {
  LocationFetcherAsset(super.facultyConfig);

  @override
  Future<List<LocationGroup>> getLocations() async {
    if (facultyConfig.assetPath == null) {
      throw Exception('No asset fallback available for ${facultyConfig.name}');
    }
    final json = await rootBundle.loadString(facultyConfig.assetPath!);
    return getFromJSON(json);
  }

  @override
  Future<List<IndoorFloorPlan>> getIndoorFloorPlans() async {
    // No asset-based indoor floor plans available yet.
    return [];
  }
}

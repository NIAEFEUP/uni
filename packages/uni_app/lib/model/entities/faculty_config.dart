class FacultyConfig {
  const FacultyConfig({
    required this.id,
    required this.name,
    required this.bounds,
    required this.buildingCodePattern,
    this.assetPath,
  });

  final String id;
  final String name;
  final FacultyBounds bounds;
  final RegExp buildingCodePattern;
  final String? assetPath; // Optional fallback JSON

  static final feup = FacultyConfig(
    id: 'feup',
    name: 'FEUP',
    bounds: const FacultyBounds(
      minLat: 41.176,
      maxLat: 41.179,
      minLon: -8.598,
      maxLon: -8.594,
    ),
    buildingCodePattern: RegExp('^([A-Z])'),
    assetPath: 'assets/text/locations/feup.json',
  );

  static final fcup = FacultyConfig(
    id: 'fcup',
    name: 'FCUP',
    bounds: const FacultyBounds(
      minLat: 41.152,
      maxLat: 41.154,
      minLon: -8.641,
      maxLon: -8.636,
    ),
    buildingCodePattern: RegExp('^(FCUP[A-Z]?)'),
    // No fallback yet
  );

  static final all = [feup, fcup];
}

class FacultyBounds {
  const FacultyBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
  });

  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;
}

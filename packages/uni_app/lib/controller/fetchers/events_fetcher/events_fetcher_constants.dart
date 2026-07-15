class EventsFetcherConstants {
  EventsFetcherConstants._();

  static const String baseUrl = 'https://niddle-staging.niaefeup.pt/api';

  /// Maps faculty acronym to Niddle numeric faculty ID (Provisory)
  static const Map<String, int> facultyIds = {'feup': 1};
}

enum FavoriteWidgetType {
  exams,
  schedule,
  printBalance,
  account,
  libraryOccupation(faculties: {"feup"}),
  libraryReservations(faculties: {"feup"}),
  busStops;

  final Set<String>? faculties;

  const FavoriteWidgetType({this.faculties});

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

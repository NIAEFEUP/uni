enum FavoriteWidgetType {
  exams,
  schedule,
  printBalance,
  account,
  restaurant,
  libraryOccupation(faculties: {"feup"}),
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

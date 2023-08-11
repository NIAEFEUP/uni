enum FavoriteWidgetType {
  exams,
  schedule,
  printBalance,
  account,
  restaurant,
  libraryOccupation(faculties: {'feup'}),
  busStops;

  const FavoriteWidgetType({this.faculties});

  final Set<String>? faculties;

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

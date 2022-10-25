enum FavoriteWidgetType {
  exams,
  schedule,
  printBalance,
  account,
  libraryOccupation(faculties: {"feup"}),
  busStops;

  final Set<String>? faculties;

  // ignore: unused_element
  const FavoriteWidgetType({this.faculties});

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

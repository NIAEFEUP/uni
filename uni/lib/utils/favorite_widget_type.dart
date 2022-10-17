enum FavoriteWidgetType { 
  exams, 
  schedule, 
  printBalance(faculties: {"fcup"}), 
  account, 
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
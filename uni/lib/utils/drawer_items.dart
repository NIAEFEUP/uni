enum DrawerItem {
  navPersonalArea('area'),
  navSchedule('horario'),
  navExams('exames'),
  navCourseUnits('cadeiras'),
  navStops('autocarros'),
  navLocations('locais', faculties: {'feup'}),
  navRestaurants('restaurantes'),
  navCalendar('calendario'),
  navLibrary('biblioteca', faculties: {'feup'}),
  navUsefulInfo('uteis', faculties: {'feup'}),
  navAbout('sobre'),
  navBugReport('bugs'),
  navLogOut('Terminar sessão');

  final String title;
  final Set<String>? faculties;

  const DrawerItem(this.title, {this.faculties});

  bool isVisible(List<String> userFaculties) {
    if (this == DrawerItem.navLogOut) {
      return false;
    }

    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

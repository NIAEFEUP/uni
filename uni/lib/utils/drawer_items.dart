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
  navLogIn('Iniciar sessão'),
  navLogOut('Terminar sessão');

  const DrawerItem(this.title, {this.faculties});

  final String title;
  final Set<String>? faculties;

  bool isVisible(List<String> userFaculties) {
    if (this == DrawerItem.navLogIn || this == DrawerItem.navLogOut) {
      return false;
    }

    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

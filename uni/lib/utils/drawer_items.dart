enum DrawerItem {
  navPersonalArea('Área Pessoal'),
  navSchedule('Horário'),
  navExams('Exames'),
  navCourseUnits('Cadeiras'),
  navStops('Autocarros'),
  navLocations('Locais', faculties: {'feup'}),
  navRestaurants('Restaurantes'),
  navCalendar('Calendário'),
  navLibrary('Biblioteca', faculties: {'feup'}),
  navUsefulInfo('Úteis', faculties: {'feup'}),
  navAbout('Sobre'),
  navBugReport('Bugs e Sugestões'),
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

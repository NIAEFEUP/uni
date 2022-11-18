enum DrawerItem {
  navPersonalArea('Área Pessoal'),
  navSchedule('Horário'),
  navExams('Exames'),
  navCourseUnits('Cadeiras'),
  navStops('Autocarros'),
  navLocations('Locais', faculties: {'feup'}),
  navCalendar('Calendário'),
  navUsefulInfo('Úteis', faculties: {'feup'}),
  navAbout('Sobre'),
  navBugReport('Bugs e Sugestões'),
  navLogOut('Terminar sessão'),
  navCantine('Restaurantes');

  final String title;
  final Set<String>? faculties;

  const DrawerItem(this.title, {this.faculties});

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    } 

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

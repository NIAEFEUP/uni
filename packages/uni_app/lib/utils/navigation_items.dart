enum NavigationItem {
  navEditPersonalArea('edit'),
  navPersonalArea('area'),
  navExams('exames'),
  navCourseUnit('cadeira'),
  navStops('autocarros'),
  navLocations('locais', faculties: {'feup'}),
  navRestaurants('restaurantes'),
  navCalendar('calendario'),
  navLibrary('biblioteca', faculties: {'feup'}),
  navFaculty('faculdade'),
  navAcademicPath('percurso_academico'),
  navProfile('perfil'),
  navSettings('definicoes'),
  navMap('mapa'),
  navLogin('login'),
  navBugreport('bug_report'),
  navSplash('splash'),
  navAboutus('sobre_nos'),
  navIntroduction('introducao');

  const NavigationItem(this.route, {this.faculties});

  final String route;
  final Set<String>? faculties;

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

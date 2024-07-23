enum NavigationItem {
  navPersonalArea('area'),
  navSchedule('horario'),
  navExams('exames'),
  navCourseUnits('cadeiras'),
  navStops('autocarros'),
  navLocations('locais', faculties: {'feup'}),
  navRestaurants('restaurantes'),
  navCalendar('calendario'),
  navLibrary('biblioteca', faculties: {'feup'}),
  navFaculty('faculdade'),
  navAcademicPath('percurso_academico'),
  navProfile('perfil'),
  navSettings('definicoes'),
  navTransports('transportes'),
  navLogin('login');

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

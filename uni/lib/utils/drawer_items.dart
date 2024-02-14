enum DrawerItem {
  navPersonalArea('area'),
  navSchedule('horario'),
  navExams('exames'),
  navCourseUnits('cadeiras'),
  navStops('autocarros'),
  navLocations('locais', faculties: {'feup'}),
  navRestaurants('restaurantes'),
  navCalendar('calendario'),
  navLibraryOccupation('biblioteca', faculties: {'feup'}),
  navLibraryReservations('reservas', faculties: {'feup'}),
  navLibrary('biblioteca', faculties: {'feup'}),
  navFaculty('faculdade'),
  navAcademicPath('percurso_academico'),
  navTransports('transportes');

  const DrawerItem(this.title, {this.faculties});

  final String title;
  final Set<String>? faculties;

  bool isVisible(List<String> userFaculties) {
    if (faculties == null) {
      return true;
    }

    return userFaculties.any((element) => faculties!.contains(element));
  }
}

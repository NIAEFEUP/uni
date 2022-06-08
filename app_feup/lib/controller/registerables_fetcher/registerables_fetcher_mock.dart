import 'package:uni/controller/registerables_fetcher/registerables_fetcher.dart';
import 'package:uni/model/class_registration_model.dart';
import 'package:uni/model/entities/course_unit.dart';

class RegisterablesFetcherMock extends RegisterablesFetcher {
  @override
  Future<List<CourseUnit>> getRegisterables() async {
    final List<CourseUnit> fetchedUnits = [
      CourseUnit(
          id: 0,
          occurrId: 484425,
          name: 'Engenharia de Software',
          abbreviation: 'ES',
          semesterCode: Semester.second.toCode(),
          semesterName: Semester.second.toName()),
      CourseUnit(
          id: 1,
          occurrId: 484442,
          name: 'Inteligência Artificial',
          abbreviation: 'IA',
          semesterCode: Semester.second.toCode(),
          semesterName: Semester.second.toName()),
      CourseUnit(
          id: 2,
          occurrId: 484381,
          name: 'Computação Paralela e Distribuída',
          abbreviation: 'CPD',
          semesterCode: Semester.second.toCode(),
          semesterName: Semester.second.toName()),
      CourseUnit(
          id: 3,
          occurrId: 484379,
          name: 'Compiladores',
          abbreviation: 'C',
          semesterCode: Semester.second.toCode(),
          semesterName: Semester.second.toName()),
      CourseUnit(
          id: 4,
          occurrId: 484431,
          name: 'Fundamentos de Segurança Informática',
          abbreviation: 'FSI',
          semesterCode: Semester.first.toCode(),
          semesterName: Semester.first.toName()),
      CourseUnit(
          id: 5,
          occurrId: 484433,
          name: 'Laboratório de Bases de Dados e Aplicações Web',
          abbreviation: 'LBAW',
          semesterCode: Semester.first.toCode(),
          semesterName: Semester.first.toName()),
      CourseUnit(
          id: 6,
          occurrId: 484430,
          name: 'Linguagens e Tecnologias Web',
          abbreviation: 'LTW',
          semesterCode: Semester.first.toCode(),
          semesterName: Semester.first.toName()),
      CourseUnit(
          id: 7,
          occurrId: 484434,
          name: 'Programação Funcional e em Lógica',
          abbreviation: 'PFL',
          semesterCode: Semester.first.toCode(),
          semesterName: Semester.first.toName()),
      CourseUnit(
          id: 8,
          occurrId: 484435,
          name: 'Redes de Computadores',
          abbreviation: 'RC',
          semesterCode: Semester.first.toCode(),
          semesterName: Semester.first.toName()),
    ];

    final String semester = '2S';

    final List<CourseUnit> registerables = [];

    for (var unit in fetchedUnits) {
      if (unit.semesterCode == semester) {
        registerables.add(unit);
      }
    }

    return registerables;
  }
}
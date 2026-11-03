import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';

class MockLectureNotifier extends LectureNotifier {
  @override
  Future<List<Lecture>?> build() async {
    return _generateMockLectures();
  }

  @override
  Future<List<Lecture>> loadFromStorage() async {
    return _generateMockLectures();
  }

  @override
  Future<List<Lecture>?> loadFromRemote() async {
    return _generateMockLectures();
  }

  List<Lecture> _generateMockLectures() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final lectures = <Lecture>[];

    final subjects = ['ES', 'BD', 'SO', 'ME', 'RCOMP'];
    final subjectNames = [
      'Engenharia de Software',
      'Bases de Dados',
      'Sistemas Operativos',
      'Métodos Estatísticos',
      'Redes de Computadores',
    ];
    final teachers = ['AAM', 'SN', 'JFS', 'HLC', 'RM'];
    final teacherNames = [
      'Ademar Aguiar',
      'Sérgio Nunes',
      'José Silva',
      'Henrique Lopes Cardoso',
      'Rui Maranhão',
    ];

    for (var weekOffset = -1; weekOffset <= 4; weekOffset++) {
      final baseMonday = monday.add(Duration(days: 7 * weekOffset));

      for (var i = 0; i < 5; i++) {
        final currentDay = baseMonday.add(Duration(days: i));
        final subjectIdx = i % subjects.length;
        final subjectIdx2 = (i + 1) % subjects.length;

        final startTime1 = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          8,
          30,
        );
        final endTime1 = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          10,
          30,
        );

        final startTime2 = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          10,
          30,
        );
        final endTime2 = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          12,
          30,
        );

        lectures
          ..add(
            Lecture(
              subjects[subjectIdx],
              subjectNames[subjectIdx],
              'T',
              startTime1,
              endTime1,
              'B112',
              teachers[subjectIdx],
              teacherNames[subjectIdx],
              12345 + i,
              '3LEIC01',
              1000 + i + (weekOffset * 100),
            ),
          )
          ..add(
            Lecture(
              subjects[subjectIdx2],
              subjectNames[subjectIdx2],
              'TP',
              startTime2,
              endTime2,
              'B315',
              teachers[subjectIdx2],
              teacherNames[subjectIdx2],
              23456 + i,
              '3LEIC01',
              2000 + i + (weekOffset * 100),
            ),
          );
      }
    }

    return lectures;
  }
}

final mockLectureProvider =
    AsyncNotifierProvider<LectureNotifier, List<Lecture>?>(
      MockLectureNotifier.new,
    );

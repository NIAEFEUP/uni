import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';

class MockExamNotifier extends ExamNotifier {
  @override
  Future<List<Exam>?> build() async {
    return _generateMockExams();
  }

  @override
  Future<List<Exam>> loadFromStorage() async {
    return _generateMockExams();
  }

  @override
  Future<List<Exam>?> loadFromRemote() async {
    return _generateMockExams();
  }

  List<Exam> _generateMockExams() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final exams = <Exam>[];

    final subjects = ['ES', 'BD', 'SO', 'ME', 'RCOM'];
    final subjectNames = [
      'Engenharia de Software',
      'Bases de Dados',
      'Sistemas Operativos',
      'Métodos Estatísticos',
      'Redes de Computadores',
    ];

    final examDays = [
      monday.add(const Duration(days: 2)),
      monday.add(const Duration(days: 4)),
      monday.add(const Duration(days: 8)),
      monday.add(const Duration(days: 10)),
      monday.add(const Duration(days: 14)),
    ];

    for (var i = 0; i < 5; i++) {
      final examDay = examDays[i];
      final start = DateTime(examDay.year, examDay.month, examDay.day, 14);
      final finish = DateTime(examDay.year, examDay.month, examDay.day, 16, 30);

      exams.add(
        Exam(
          'exam_mock_$i',
          start,
          finish,
          subjects[i],
          subjectNames[i],
          ['B112', 'B113'],
          'EN',
          'occurr_$i',
        ),
      );
    }

    return exams;
  }
}

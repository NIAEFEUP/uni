import 'package:uni/model/entities/exam.dart';

bool isHighlighted(Exam exam) {
  return (exam.examType.contains('''EN''')) ||
      (exam.examType.contains('''MT'''));
}
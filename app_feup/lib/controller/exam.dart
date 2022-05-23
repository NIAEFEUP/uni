import 'package:uni/model/entities/exam.dart';

/// Determines if the exam is highlighted or not.
///
/// The exam is highlighted if it is of
/// the type 'MT' ('Mini-testes') or 'EN' ('Normal').
bool isHighlighted(Exam exam) {
  return (exam.examType.contains('''EN''')) ||
      (exam.examType.contains('''MT'''));
}

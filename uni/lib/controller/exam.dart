import 'package:uni/model/entities/exam.dart';

/// Determines if the exam is highlighted or not.
/// 
/// The exam is highlighted if it is hidden
bool isHighlighted(Exam exam) {
  return exam.isHidden;
}
class CourseUnitStatistics {
  const CourseUnitStatistics({
    required this.schoolYear,
    required this.enrolled,
    required this.approved,
    required this.failed,
    required this.notEvaluated,
  });

  final String schoolYear;
  final int enrolled;
  final int approved;
  final int failed;
  final int notEvaluated;

  bool get isEvaluationEmpty => approved == 0 && failed == 0;

  CourseUnitStatistics copyWith({
    String? schoolYear,
    int? enrolled,
    int? approved,
    int? failed,
    int? notEvaluated,
  }) {
    return CourseUnitStatistics(
      schoolYear: schoolYear ?? this.schoolYear,
      enrolled: enrolled ?? this.enrolled,
      approved: approved ?? this.approved,
      failed: failed ?? this.failed,
      notEvaluated: notEvaluated ?? this.notEvaluated,
    );
  }
}

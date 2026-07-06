class CourseUnitResult {
  const CourseUnitResult({
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
}

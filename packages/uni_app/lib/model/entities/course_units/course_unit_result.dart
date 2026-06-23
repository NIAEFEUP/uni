class CourseUnitResult {
  const CourseUnitResult({
    required this.schoolYear,
    required this.enrolled,
    required this.evaluated,
    required this.approved,
    required this.failed,
    required this.notEvaluated,
    required this.evaluatedEnrolledRatio,
    required this.approvedEnrolledRatio,
    required this.approvedEvaluatedRatio,
  });

  final String schoolYear;
  final int enrolled;
  final int evaluated;
  final int approved;
  final int failed;
  final int notEvaluated;
  final double evaluatedEnrolledRatio;
  final double approvedEnrolledRatio;
  final double approvedEvaluatedRatio;
}

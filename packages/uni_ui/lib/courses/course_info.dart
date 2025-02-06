class CourseInfo {
  final String abbreviation;
  final int enrollmentYear;
  final int? conclusionYear;

  CourseInfo({
    required this.abbreviation,
    required this.enrollmentYear,
    this.conclusionYear,
  });
}

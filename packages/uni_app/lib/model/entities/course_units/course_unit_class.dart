class CourseUnitClass {
  CourseUnitClass(this.className, this.students);
  String className;
  List<CourseUnitStudent> students;
}

class CourseUnitStudent {
  CourseUnitStudent(
    this.name,
    this.number,
    this.mail,
    this.photo,
    this.profile,
  );
  String name;
  int number;
  String mail;
  Uri photo;
  Uri profile;
}

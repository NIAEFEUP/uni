class CourseUnitClass {
  String className;
  List<CourseUnitStudent> students;
  CourseUnitClass(this.className, this.students);
}

class CourseUnitStudent {
  String name;
  int number;
  String mail;
  Uri photo;
  Uri profile;

  CourseUnitStudent(
      this.name, this.number, this.mail, this.photo, this.profile);
}

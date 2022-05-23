enum Semester { first, second }

extension SemesterUtils on Semester {
  int toInt() {
    switch (this) {
      case Semester.first:
        return 1;
      case Semester.second:
        return 2;
      default:
        return null;
    }
  }

  static Semester fromInt(int i) {
    switch (i) {
      case 1:
        return Semester.first;
      case 2:
        return Semester.second;
      default:
        return null;
    }
  }

  static Semester fromCode(String semesterCode) {
    switch (semesterCode) {
      case '1S':
        return Semester.first;
      case '2S':
        return Semester.second;
      default:
        return null;
    }
  }

  String toCode() {
    switch (this) {
      case Semester.first:
        return '1S';
      case Semester.second:
        return '2S';
      default:
        return null;
    }
  }

  String toName() {
    switch (this) {
      case Semester.first:
        return '1º Semestre';
      case Semester.second:
        return '2º Semestre';
      default:
        return null;
    }
  }
}

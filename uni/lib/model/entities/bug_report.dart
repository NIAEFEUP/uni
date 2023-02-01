/// Stores information about Bug Report
import 'package:tuple/tuple.dart';

class BugReport{
  final String title;
  final String text;
  final String email;
  final Tuple2<String,String>? bugLabel;
  final List<String> faculty;
  BugReport(
      this.title,
      this.text,
      this.email,
      this.bugLabel,
      this.faculty
      );
  Map<String,dynamic> toMap() => {
      'title':title,
      'text':text,
      'email':email,
      'bugLabel':bugLabel!.item2,
      'faculties':faculty
    };
}
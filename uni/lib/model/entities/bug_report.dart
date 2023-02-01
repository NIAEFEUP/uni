/// Stores information about bug report
import 'package:tuple/tuple.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class BugReport{
  final String title;
  final String text;
  final String email;
  final Tuple2<String,String>? bugLabel;
  BugReport(
      this.title,
      this.text,
      this.email,
      this.bugLabel,
      );
  Future<List<String>> getFaculties() async{
    return await AppSharedPreferences.getUserFaculties();
  }
  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'text':text,
      'email':email,
      'bugLabel':bugLabel!.item2,
      'faculties':getFaculties()
    };
  }
}
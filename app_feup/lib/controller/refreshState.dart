import '../redux/actionCreators.dart';

Future<Null> handleRefresh() async{
  getUserExams();
  getUserSchedule();
  return null;
}
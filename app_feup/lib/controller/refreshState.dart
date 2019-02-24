import '../redux/actionCreators.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/AppState.dart';

Future<Null> handleRefresh() async{
  getUserExams();
  getUserSchedule();
  return null;
}
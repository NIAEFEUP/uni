import 'package:app_feup/redux/actionCreators.dart';

loadUserInfoToState(store){
  store.dispatch(updateStateBasedOnLocalUserExams());
  store.dispatch(updateStateBasedOnLocalUserLectures());
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
}

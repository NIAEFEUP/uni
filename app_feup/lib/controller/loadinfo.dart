import 'package:app_feup/redux/actionCreators.dart';

loadUserInfoToState(store){
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
  store.dispatch(getUserPrintBalance());
  store.dispatch(getUserFeesBalance());
}

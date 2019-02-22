import 'package:app_feup/redux/actionCreators.dart';

loadUserInfoToState(store){
  store.dispatch(fetchUserInfo());
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
}

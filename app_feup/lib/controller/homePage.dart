import 'package:app_feup/redux/actionCreators.dart';

loadUserInfoToState(store){
  store.dispatch(getUserExams());
}

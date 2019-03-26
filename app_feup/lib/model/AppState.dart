import 'package:app_feup/model/HomePageModel.dart';

class AppState {

  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      "schedule": [],
      "exams": [],
      "selected_page": "Área Pessoal",
      "favoriteCards": [FAVORITE_WIDGET_TYPE.EXAMS, FAVORITE_WIDGET_TYPE.SCHEDULE, FAVORITE_WIDGET_TYPE.EXAMS, FAVORITE_WIDGET_TYPE.SCHEDULE]
    };
  }

  AppState(Map content) {
    if (content != null) {
      this.content = content;
    } else {
      this.content = this.getInitialContent();
    }
  }

  AppState cloneAndUpdateValue(key, value){
    return new AppState(
        Map.from(this.content)
          ..[key] = value);
  }

}
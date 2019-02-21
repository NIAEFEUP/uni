class AppState {

  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      "schedule": [],
      "exams": [],
      "selected_page": "Área Pessoal",
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
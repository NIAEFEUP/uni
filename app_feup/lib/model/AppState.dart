class AppState{

  Map content;

  Map getInitialContent() {
    return {
      "cookies": "",
      "exams": [],
      "lectures": []
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
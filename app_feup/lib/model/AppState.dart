class AppState {

  Map content = Map<String, dynamic>();

  AppState(Map content) {
    if (content != null) {
      this.content = content;
    }
  }

  AppState cloneAndUpdateValue(key, value){
    return new AppState(
        Map.from(this.content)
          ..[key] = value);
  }

}
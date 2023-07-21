extension DurationStringFormatter on Duration {
  static final formattingRegExp = RegExp('{}');

  String toFormattedString(String singularPhrase, String pluralPhrase,
      {String term = '{}'}) {
    if (!singularPhrase.contains(term) || !pluralPhrase.contains(term)) {
      throw ArgumentError(
          "singularPhrase or plurarPhrase don't have a string that can be formatted...");
    }
    if (inSeconds == 1) {
      return singularPhrase.replaceAll(formattingRegExp, '$inSeconds segundo');
    }
    if (inSeconds < 60) {
      return pluralPhrase.replaceAll(formattingRegExp, '$inSeconds segundos');
    }
    if (inMinutes == 1) {
      return singularPhrase.replaceAll(formattingRegExp, '$inMinutes minuto');
    }
    if (inMinutes < 60) {
      return pluralPhrase.replaceAll(formattingRegExp, '$inMinutes minutos');
    }
    if (inHours == 1) {
      return singularPhrase.replaceAll(formattingRegExp, '$inHours hora');
    }
    if (inHours < 24) {
      return pluralPhrase.replaceAll(formattingRegExp, '$inHours horas');
    }
    if (inDays == 1) {
      return singularPhrase.replaceAll(formattingRegExp, '$inDays dia');
    }
    if (inDays <= 7) {
      return pluralPhrase.replaceAll(formattingRegExp, '$inDays dias');
    }
    if ((inDays / 7).floor() == 1) {
      return singularPhrase.replaceAll(
          formattingRegExp, '${(inDays / 7).floor()} semana');
    }
    if ((inDays / 7).floor() > 1) {
      return pluralPhrase.replaceAll(
          formattingRegExp, '${(inDays / 7).floor()} semanas');
    }
    if ((inDays / 30).floor() == 1) {
      return singularPhrase.replaceAll(
          formattingRegExp, '${(inDays / 30).floor()} mês');
    }
    return pluralPhrase.replaceAll(
        formattingRegExp, '${(inDays / 30).floor()} meses');
  }
}

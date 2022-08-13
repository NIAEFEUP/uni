Map<String, String> getUrlQueryParameters(String url) {
  final Map<String, String> queryParameters = {};

  int lastSlashIndex = url.lastIndexOf('/');
  if (lastSlashIndex >= 0) {
    url = url.substring(lastSlashIndex + 1);
  }

  int queryStartIndex = url.lastIndexOf('?');
  if (queryStartIndex < 0) {
    return {};
  }
  url = url.substring(queryStartIndex + 1);

  List<String> params = url.split('&');
  for (String param in params) {
    List<String> keyValue = param.split('=');
    if (keyValue.length != 2) {
      continue;
    }
    queryParameters[keyValue[0].trim()] = keyValue[1].trim();
  }
  return queryParameters;
}

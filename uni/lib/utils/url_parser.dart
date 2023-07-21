Map<String, String> getUrlQueryParameters(String url) {
  final queryParameters = <String, String>{};

  final lastSlashIndex = url.lastIndexOf('/');
  if (lastSlashIndex >= 0) {
    url = url.substring(lastSlashIndex + 1);
  }

  final queryStartIndex = url.lastIndexOf('?');
  if (queryStartIndex < 0) {
    return {};
  }
  url = url.substring(queryStartIndex + 1);

  final params = url.split('&');
  for (final param in params) {
    final keyValue = param.split('=');
    if (keyValue.length != 2) {
      continue;
    }
    queryParameters[keyValue[0].trim()] = keyValue[1].trim();
  }
  return queryParameters;
}

Map<String, String> getUrlQueryParameters(String url) {
  final queryParameters = <String, String>{};
  var queryString = '';

  final lastSlashIndex = url.lastIndexOf('/');
  if (lastSlashIndex >= 0) {
    queryString = url.substring(lastSlashIndex + 1);
  }

  final queryStartIndex = queryString.lastIndexOf('?');
  if (queryStartIndex < 0) {
    return {};
  }
  queryString = queryString.substring(queryStartIndex + 1);

  final params = queryString.split('&');
  for (final param in params) {
    final keyValue = param.split('=');
    if (keyValue.length != 2) {
      continue;
    }
    queryParameters[keyValue[0].trim()] = keyValue[1].trim();
  }
  return queryParameters;
}

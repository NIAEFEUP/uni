import 'package:http/http.dart' as http;

class BaseRequestOptions {
  BaseRequestOptions({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Uri get baseUrl => Uri(scheme: 'https', host: 'sigarra.up.pt');

  BaseRequestOptions copyWith({
    http.Client? client,
  }) {
    return BaseRequestOptions(
      client: client ?? this.client,
    );
  }
}

class FacultyRequestOptions extends BaseRequestOptions {
  FacultyRequestOptions({
    this.faculty = 'up',
    this.language = 'pt',
    super.client,
  });

  final String faculty;
  final String language;

  @override
  Uri get baseUrl => super.baseUrl.resolve('/$faculty/$language/');

  @override
  FacultyRequestOptions copyWith({
    String? language,
    String? faculty,
    http.Client? client,
  }) {
    return FacultyRequestOptions(
      language: language ?? this.language,
      faculty: faculty ?? this.faculty,
      client: client ?? this.client,
    );
  }
}

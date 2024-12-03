import 'package:http/http.dart' as http;

abstract class BaseRequestOptions {
  BaseRequestOptions({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Uri get baseUrl;

  BaseRequestOptions copyWith({
    http.Client? client,
  });
}

class SigarraRequestOptions extends BaseRequestOptions {
  SigarraRequestOptions({super.client});

  @override
  Uri get baseUrl => Uri(scheme: 'https', host: 'sigarra.up.pt');

  @override
  SigarraRequestOptions copyWith({
    http.Client? client,
  }) {
    return SigarraRequestOptions(
      client: client ?? this.client,
    );
  }
}

class FacultyRequestOptions extends SigarraRequestOptions {
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

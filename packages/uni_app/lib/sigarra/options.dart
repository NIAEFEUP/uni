import 'package:http/http.dart' as http;
import 'package:uni/sigarra/instances.dart';

abstract class BaseRequestOptions {
  BaseRequestOptions({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Uri get baseUrl;

  BaseRequestOptions copyWith({http.Client? client});
}

class SigarraRequestOptions extends BaseRequestOptions {
  SigarraRequestOptions({super.client});

  @override
  Uri get baseUrl => Uri(scheme: 'https', host: 'sigarra.up.pt');

  @override
  SigarraRequestOptions copyWith({http.Client? client}) {
    return SigarraRequestOptions(client: client ?? this.client);
  }
}

class InstanceRequestOptions extends SigarraRequestOptions {
  InstanceRequestOptions({
    this.instance = Instance.up,
    this.language = 'pt',
    super.client,
  });

  final Instance instance;
  final String language;

  @override
  Uri get baseUrl => super.baseUrl.resolve('/$instance/$language/');

  @override
  InstanceRequestOptions copyWith({
    String? language,
    Instance? instance,
    http.Client? client,
  }) {
    return InstanceRequestOptions(
      language: language ?? this.language,
      instance: instance ?? this.instance,
      client: client ?? this.client,
    );
  }
}

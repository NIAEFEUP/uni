import 'package:uni/sigarra/response.dart';

abstract class Endpoint<T extends EndpointResponse> {
  const Endpoint();

  Future<T> call();
}

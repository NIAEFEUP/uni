import 'package:uni/sigarra/endpoint.dart';
import 'package:uni/sigarra/endpoints/html/search/global_student_search/parameters.dart';
import 'package:uni/sigarra/options.dart';
import 'package:uni/sigarra/response.dart';

class GlobalStudentSearch extends Endpoint<EndpointResponse> {
  const GlobalStudentSearch({required this.parameters, this.options});

  final GlobalStudentSearchParameters parameters;
  final SigarraRequestOptions? options;

  @override
  Future<EndpointResponse> call() async {
    final options = InstanceRequestOptions(client: this.options?.client);

    final searchUrl = options.baseUrl.resolve('u_fest_geral.querylist');

    final response = await options.client.post(
      searchUrl,
      body: {'p_user': username, 'p_pass': password},
    );

    return _parse(response);
  }
}

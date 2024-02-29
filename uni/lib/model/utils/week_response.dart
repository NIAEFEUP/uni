import 'package:http/http.dart' as http;
import 'package:uni/model/utils/time/week.dart';

class WeekResponse {
  WeekResponse(this.week, this.response);

  final Week week;
  final http.Response response;

  @override
  String toString() {
    return 'WeekResponse{week: $week, response: $response}';
  }
}

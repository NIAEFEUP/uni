import 'package:http/http.dart' as http;
import 'package:uni/model/utils/time/week.dart';

class WeekResponse {
  WeekResponse(this.week, this.innerResponse);

  final Week week;
  final http.Response innerResponse;

  @override
  String toString() {
    return 'WeekResponse{week: $week, response: $innerResponse}';
  }
}

// Stores information about Bug Report
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'bug_report.g.dart';

class TupleConverter extends JsonConverter<Tuple2<String, String>?, String?> {
  const TupleConverter();

  @override
  Tuple2<String, String>? fromJson(String? json) {
    if (json == null) return null;
    return Tuple2<String, String>('', json);
  }

  @override
  String? toJson(Tuple2<String, String>? object) {
    if (object == null) return null;
    return object.item2;
  }
}

@TupleConverter()
@JsonSerializable()
class BugReport {
  BugReport(this.title, this.text, this.email, this.bugLabel, this.faculties);

  factory BugReport.fromJson(Map<String, dynamic> json) =>
      _$BugReportFromJson(json);

  final String title;
  final String text;
  final String email;
  final Tuple2<String, String>? bugLabel;
  final List<String> faculties;

  Map<String, dynamic> toJson() => _$BugReportToJson(this);
}

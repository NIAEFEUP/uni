/// Stores information about Bug Report
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'bug_report.g.dart';

class TupleConverter extends JsonConverter<Tuple2<String, String>?, Map<String, dynamic>?> {
  const TupleConverter();

  @override
  Tuple2<String, String>? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Tuple2<String, String>(json['item1'] as String, json['item2'] as String);
  }

  @override
  Map<String, dynamic>? toJson(Tuple2<String, String>? object) {
    if (object == null) return null;
    return {
      'item1': object.item1,
      'item2': object.item2,
    };
  }
}

@TupleConverter()
@JsonSerializable()
class BugReport {
  final String title;
  final String text;
  final String email;
  final Tuple2<String, String>? bugLabel;
  final List<String> faculties;
  BugReport(this.title, this.text, this.email, this.bugLabel, this.faculties);
  factory BugReport.fromJson(Map<String,dynamic> json) => _$BugReportFromJson(json);
  Map<String, dynamic> toJson() => _$BugReportToJson(this);
}

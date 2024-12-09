// Stores information about Bug Report
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/converters/tuple_converter.dart';

part '../../generated/model/entities/bug_report.g.dart';

@TupleConverter()
@JsonSerializable()
class BugReport {
  BugReport(this.title, this.text, this.email, this.bugLabel, this.faculties);

  factory BugReport.fromJson(Map<String, dynamic> json) =>
      _$BugReportFromJson(json);

  final String title;
  final String text;
  final String email;
  final (String, String)? bugLabel;
  final List<String> faculties;

  Map<String, dynamic> toJson() => _$BugReportToJson(this);
}

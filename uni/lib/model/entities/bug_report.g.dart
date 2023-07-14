// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BugReport _$BugReportFromJson(Map<String, dynamic> json) => BugReport(
      json['title'] as String,
      json['text'] as String,
      json['email'] as String,
      const TupleConverter()
          .fromJson(json['bugLabel'] as Map<String, dynamic>?),
      (json['faculties'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BugReportToJson(BugReport instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'email': instance.email,
      'bugLabel': const TupleConverter().toJson(instance.bugLabel),
      'faculties': instance.faculties,
    };

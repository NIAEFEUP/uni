// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/bug_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BugReport _$BugReportFromJson(Map<String, dynamic> json) => BugReport(
      json['title'] as String,
      json['text'] as String,
      json['email'] as String,
      json['bugLabel'] as String?,
      (json['faculties'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BugReportToJson(BugReport instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'email': instance.email,
      'bugLabel': instance.bugLabel,
      'faculties': instance.faculties,
    };

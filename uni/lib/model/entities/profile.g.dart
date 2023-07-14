// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      courses: json['courses'],
      printBalance: json['printBalance'] as String? ?? '',
      feesBalance: json['feesBalance'] as String? ?? '',
      feesLimit: json['feesLimit'] == null
          ? null
          : DateTime.parse(json['feesLimit'] as String),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'courses': instance.courses,
      'printBalance': instance.printBalance,
      'feesBalance': instance.feesBalance,
      'feesLimit': instance.feesLimit?.toIso8601String(),
    };

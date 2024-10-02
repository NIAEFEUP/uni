// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../session/flows/credentials/session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsSession _$CredentialsSessionFromJson(Map<String, dynamic> json) =>
    CredentialsSession(
      username: json['username'] as String,
      cookies: (json['cookies'] as List<dynamic>)
          .map((e) => const CookieConverter().fromJson(e as String))
          .toList(),
      faculties:
          (json['faculties'] as List<dynamic>).map((e) => e as String).toList(),
      password: json['password'] as String,
    );

Map<String, dynamic> _$CredentialsSessionToJson(CredentialsSession instance) =>
    <String, dynamic>{
      'username': instance.username,
      'faculties': instance.faculties,
      'cookies': instance.cookies.map(const CookieConverter().toJson).toList(),
      'password': instance.password,
    };

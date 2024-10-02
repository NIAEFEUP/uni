// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../session/flows/federated/session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FederatedSession _$FederatedSessionFromJson(Map<String, dynamic> json) =>
    FederatedSession(
      username: json['username'] as String,
      cookies: (json['cookies'] as List<dynamic>)
          .map((e) => const CookieConverter().fromJson(e as String))
          .toList(),
      faculties:
          (json['faculties'] as List<dynamic>).map((e) => e as String).toList(),
      credential:
          Credential.fromJson(json['credential'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FederatedSessionToJson(FederatedSession instance) =>
    <String, dynamic>{
      'username': instance.username,
      'faculties': instance.faculties,
      'cookies': instance.cookies.map(const CookieConverter().toJson).toList(),
      'credential': instance.credential.toJson(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../controller/session/credentials/request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsSessionRequest _$CredentialsSessionRequestFromJson(
        Map<String, dynamic> json) =>
    CredentialsSessionRequest(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$CredentialsSessionRequestToJson(
        CredentialsSessionRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

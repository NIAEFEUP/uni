// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      line: json['line'] as String,
      destination: json['destination'] as String,
      timeRemaining: json['timeRemaining'] as int,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'line': instance.line,
      'destination': instance.destination,
      'timeRemaining': instance.timeRemaining,
    };

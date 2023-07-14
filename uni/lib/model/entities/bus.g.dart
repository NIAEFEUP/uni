// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
      busCode: json['busCode'] as String,
      destination: json['destination'] as String,
      direction: json['direction'] as bool? ?? false,
    );

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
      'busCode': instance.busCode,
      'destination': instance.destination,
      'direction': instance.direction,
    };

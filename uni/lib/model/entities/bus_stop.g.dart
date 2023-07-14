// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusStopData _$BusStopDataFromJson(Map<String, dynamic> json) => BusStopData(
      configuredBuses: (json['configuredBuses'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      favorited: json['favorited'] as bool? ?? false,
      trips: (json['trips'] as List<dynamic>?)
              ?.map((e) => Trip.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BusStopDataToJson(BusStopData instance) =>
    <String, dynamic>{
      'configuredBuses': instance.configuredBuses.toList(),
      'favorited': instance.favorited,
      'trips': instance.trips,
    };

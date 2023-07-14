// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reference _$ReferenceFromJson(Map<String, dynamic> json) => Reference(
      json['description'] as String,
      DateTime.parse(json['limitDate'] as String),
      json['entity'] as int,
      json['reference'] as int,
      (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ReferenceToJson(Reference instance) => <String, dynamic>{
      'description': instance.description,
      'limitDate': instance.limitDate.toIso8601String(),
      'entity': instance.entity,
      'reference': instance.reference,
      'amount': instance.amount,
    };

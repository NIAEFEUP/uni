// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reference _$ReferenceFromJson(Map<String, dynamic> json) => Reference(
      json['description'] as String,
      const DateTimeConverter().fromJson(json['limitDate'] as String),
      json['entity'] as int,
      json['reference'] as int,
      (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ReferenceToJson(Reference instance) => <String, dynamic>{
      'description': instance.description,
      'limitDate': const DateTimeConverter().toJson(instance.limitDate),
      'entity': instance.entity,
      'reference': instance.reference,
      'amount': instance.amount,
    };

import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/local_storage/database-nosql/adapter.dart';
import 'package:uni/model/entities/exam.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class AdaptersRepository {
  // List to maintain predefined models
  final List<DBAdapter<dynamic>> _adapters = [
    DBAdapter<Exam>(
      Exam.fromJson,
      0,
    ),
  ];

  void registerAdapters() {
    _adapters.forEach(Hive.registerAdapter);
  }
}

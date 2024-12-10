import 'package:hive_flutter/adapters.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T obj);

class DBAdapter<T> extends TypeAdapter<T> {
  DBAdapter(this.fromJson, this.typeId);

  final FromJson<T> fromJson;
  @override
  final int typeId;

  @override
  T read(BinaryReader reader) {
    final map = reader.readMap() as Map<String, dynamic>;
    return fromJson(map);
  }

  @override
  void write(BinaryWriter writer, T obj) {
    writer.writeMap(obj.toJson()!);
  }
}

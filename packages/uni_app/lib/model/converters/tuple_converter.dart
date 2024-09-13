import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

class TupleConverter extends JsonConverter<Tuple2<String, String>?, String?> {
  const TupleConverter();

  @override
  Tuple2<String, String>? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return Tuple2<String, String>('', json);
  }

  @override
  String? toJson(Tuple2<String, String>? object) {
    if (object == null) {
      return null;
    }
    return object.item2;
  }
}

import 'package:json_annotation/json_annotation.dart';

class TupleConverter extends JsonConverter<(String, String)?, String?> {
  const TupleConverter();

  @override
  (String, String)? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return ('', json);
  }

  @override
  String? toJson((String, String)? object) {
    if (object == null) {
      return null;
    }
    return object.$2;
  }
}

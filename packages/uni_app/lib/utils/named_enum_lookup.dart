Map<String, T> _buildNameMap<T extends Enum>(List<T> values) {
  return values.fold<Map<String, T>>({}, (map, value) {
    map[value.name] = value;
    return map;
  });
}

class NamedEnumLookup<T extends Enum> {

  NamedEnumLookup(List<T> values) : _nameMap = _buildNameMap(values);

  final Map<String, T> _nameMap;

  T? findOrNull(String name) => _nameMap[name];

  T find(String name) {
    final value = _nameMap[name];
    
    if (value == null) {
      throw Exception('No enum value found for name "$name"');
    }

    return value;
  }
}

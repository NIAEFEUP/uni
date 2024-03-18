class Sheet {
  Sheet({
    required this.professors,
    required this.content,
    required this.evaluation,
  });
  List<Professor> professors;
  String content;
  String evaluation;
}

class Professor {
  Professor({
    required this.code,
    required this.name,
    required this.classes,
    required this.regent,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      code: json['code'].toString(),
      name: json['name'].toString(),
      classes: [],
      regent: true,
    );
  }

  String code;
  String name;
  List<String> classes;
  bool regent;

  @override
  bool operator ==(Object other) {
    if (other is Professor) {
      return other.code == code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;
}

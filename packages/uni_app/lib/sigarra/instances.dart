import 'package:json_annotation/json_annotation.dart';
import 'package:uni/utils/lazy.dart';
import 'package:uni/utils/named_enum_lookup.dart';

enum InstanceType { faculty, other }

/// An enum containing a list of all of the SIGARRA instances related to the
/// University of Porto.
enum Instance {
  // Global instance

  /// Universidade do Porto
  up,

  // Faculty-specific instances

  /// Escola Superior de Enfermagem do Porto
  esep.faculty(),
  /// Faculdade de Arquitetura da Universidade do Porto
  faup.faculty(),
  /// Faculdade de Belas Artes da Universidade do Porto
  fbaup.faculty(),
  /// Faculdade de Ciências da Nutrição e Alimentação da Universidade do Porto
  fcnaup.faculty(),
  /// Faculdade de Ciências da Universidade do Porto
  fcup.faculty(),
  /// Faculdade de Desporto da Universidade do Porto
  fadeup.faculty(),
  /// Faculdade de Direito da Universidade do Porto
  fdup.faculty(),
  /// Faculdade de Economia da Universidade do Porto
  fep.faculty(),
  /// Faculdade de Engenharia da Universidade do Porto
  feup.faculty(),
  /// Faculdade de Farmácia da Universidade do Porto
  ffup.faculty(),
  /// Faculdade de Letras da Universidade do Porto
  flup.faculty(),
  /// Faculdade de Medicina da Universidade do Porto
  fmup.faculty(),
  /// Faculdade de Medicina Dentária da Universidade do Porto
  fmdup.faculty(),
  /// Faculdade de Psicologia e de Ciências da Educação da Universidade do Porto
  fpceup.faculty(),
  /// Instituto de Ciências Biomédicas Abel Salazar
  icbas.faculty(),

  // Other instances

  /// Centro de Desporto da Universidade do Porto
  cdup,
  /// Reitoria
  reitoria,
  /// Serviços Partilhados da Universidade do Porto
  spup,
  /// Serviços de Acção Social da Universidade do Porto
  sasup;

  const Instance() : type = InstanceType.other;
  const Instance.faculty() : type = InstanceType.faculty;

  /// The type of  this [Instance].
  final InstanceType type;

  static final allFaculties =
      Instance.values
          .where((instance) => instance.type == InstanceType.faculty)
          .toList();

  static final _lookup = Lazy(() => NamedEnumLookup(Instance.values));

  static Instance fromName(String name) {
    return _lookup.value.find(name);
  }

  static List<Instance> fromNames(List<String> names) {
    return names.map(Instance.fromName).toList();
  }
}

class InstanceConverter implements JsonConverter<Instance, String> {
  const InstanceConverter();

  @override
  Instance fromJson(String name) => Instance.fromName(name);

  @override
  String toJson(Instance object) => object.name;
}

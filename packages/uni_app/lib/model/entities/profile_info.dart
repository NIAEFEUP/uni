import 'package:objectbox/objectbox.dart';

/// Stores information about the user's profile.
@Entity()
class ProfileInfo {
  ProfileInfo({
    List<List<String>>? profileInfo,
    List<List<String>>? nationalities,
    List<List<String>>? identification,
    List<List<String>>? contacts,
    List<List<String>>? addresses,
  }) : profileInfo = profileInfo ?? [],
       nationalities = nationalities ?? [],
       identification = identification ?? [],
       contacts = contacts ?? [],
       addresses = addresses ?? [];

  /// Creates a new instance from a JSON object.
  factory ProfileInfo.fromList(List<List<List<String>>> list) {
    return ProfileInfo(
      profileInfo: list[0],
      nationalities: list[1],
      identification: list[2],
      contacts: list[3],
      addresses: list[4],
    );
  }

  @Id()
  int? id;
  List<List<String>> profileInfo;
  List<List<String>> nationalities;
  List<List<String>> identification;
  List<List<String>> contacts;
  List<List<String>> addresses;

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<(String, List<List<String>>)> keymapValues() {
    return [
      ('profileInfo', profileInfo),
      ('nationalities', nationalities),
      ('identification', identification),
      ('contacts', contacts),
      ('addresses', addresses),
    ];
  }
}

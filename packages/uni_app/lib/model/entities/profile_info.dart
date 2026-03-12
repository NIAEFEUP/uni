import 'package:objectbox/objectbox.dart';

/// Stores information about the user's profile.
@Entity()
class ProfileInfo {
  ProfileInfo({
    Map<String, String>? profileInfo,
    Map<String, String>? nationalities,
    Map<String, String>? identification,
    Map<String, String>? contacts,
    Map<String, String>? addresses,
  }) : profileInfo = profileInfo ?? <String, String>{},
       nationalities = nationalities ?? <String, String>{},
       identification = identification ?? <String, String>{},
       contacts = contacts ?? <String, String>{},
       addresses = addresses ?? <String, String>{};

  /// Creates a new instance from a JSON object.
  factory ProfileInfo.fromList(List<Map<String, String>> list) {
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
  Map<String, String> profileInfo;
  Map<String, String> nationalities;
  Map<String, String> identification;
  Map<String, String> contacts;
  Map<String, String> addresses;

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<(String, Map<String, String>)> keymapValues() {
    return [
      ('profileInfo', profileInfo),
      ('nationalities', nationalities),
      ('identification', identification),
      ('contacts', contacts),
      ('addresses', addresses),
    ];
  }
}

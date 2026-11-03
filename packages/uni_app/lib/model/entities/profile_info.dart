import 'dart:convert';
import 'package:objectbox/objectbox.dart';

/// Stores information about the user's profile.
@Entity()
class ProfileInfo {
  ProfileInfo({
    this.id = 0,
    this.dbProfileInfo = '{}',
    this.dbNationalities = '{}',
    this.dbIdentification = '{}',
    this.dbContacts = '{}',
    this.dbAddresses = '{}',
  });

  factory ProfileInfo.fromList(List<Map<String, String>> list) {
    return ProfileInfo(
      dbProfileInfo: jsonEncode(list.isNotEmpty ? list[0] : <String, String>{}),
      dbNationalities: jsonEncode(
        list.length > 1 ? list[1] : <String, String>{},
      ),
      dbIdentification: jsonEncode(
        list.length > 2 ? list[2] : <String, String>{},
      ),
      dbContacts: jsonEncode(list.length > 3 ? list[3] : <String, String>{}),
      dbAddresses: jsonEncode(list.length > 4 ? list[4] : <String, String>{}),
    );
  }

  @Id()
  int id;

  String dbProfileInfo;
  String dbNationalities;
  String dbIdentification;
  String dbContacts;
  String dbAddresses;

  @Transient()
  Map<String, String> get profileInfo =>
      Map.castFrom<dynamic, dynamic, String, String>(
        jsonDecode(dbProfileInfo) as Map,
      );
  set profileInfo(Map<String, String> value) =>
      dbProfileInfo = jsonEncode(value);

  @Transient()
  Map<String, String> get nationalities =>
      Map.castFrom<dynamic, dynamic, String, String>(
        jsonDecode(dbNationalities) as Map,
      );
  set nationalities(Map<String, String> value) =>
      dbNationalities = jsonEncode(value);

  @Transient()
  Map<String, String> get identification =>
      Map.castFrom<dynamic, dynamic, String, String>(
        jsonDecode(dbIdentification) as Map,
      );
  set identification(Map<String, String> value) =>
      dbIdentification = jsonEncode(value);

  @Transient()
  Map<String, String> get contacts =>
      Map.castFrom<dynamic, dynamic, String, String>(
        jsonDecode(dbContacts) as Map,
      );
  set contacts(Map<String, String> value) => dbContacts = jsonEncode(value);

  @Transient()
  Map<String, String> get addresses =>
      Map.castFrom<dynamic, dynamic, String, String>(
        jsonDecode(dbAddresses) as Map,
      );
  set addresses(Map<String, String> value) => dbAddresses = jsonEncode(value);

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

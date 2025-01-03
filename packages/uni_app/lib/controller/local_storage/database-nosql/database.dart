import 'package:path_provider/path_provider.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/objectbox.g.dart';

class Database {
  factory Database() {
    return _instance;
  }
  Database._internal();
  static final Database _instance = Database._internal();

  late final Store _store;

  late final Box<Profile> _profileBox;

  Future<void> init() async {
    //TODO(thePeras): Add error handling to reset database if it fails to open
    final appDir = await getApplicationDocumentsDirectory();
    final storePath = '${appDir.path}/database';
    _store = await openStore(directory: storePath);
    _profileBox = _store.box<Profile>();
  }

  Profile getProfile() {
    return _profileBox.isEmpty() ? Profile() : _profileBox.getAll().first;
  }

  // Add persistent property and only save values if its true
  void saveProfile(Profile profile) {
    _profileBox
      ..removeAll()
      ..put(profile);
  }

  void clear() {
    _profileBox.removeAll();
  }

  void close() {
    _store.close();
  }
}

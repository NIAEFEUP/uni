import 'package:path_provider/path_provider.dart';
import 'package:uni/objectbox.g.dart';

class ObjectBoxStore {
  ObjectBoxStore._create(this._store);

  static ObjectBoxStore? _instance;

  late final Store _store;

  static Future<ObjectBoxStore> init() async {
    if (_instance == null) {
      final appDir = await getApplicationDocumentsDirectory();
      final storePath = '${appDir.path}/objectbox';

      final store = await openStore(directory: storePath);
      _instance = ObjectBoxStore._create(store);
    }
    return _instance!;
  }

  Store get store => _store;

  void dispose() {
    _store.close();
    _instance = null;
  }

  static Future<void> remove() async {
    final appDir = await getApplicationDocumentsDirectory();
    final storePath = '${appDir.path}/objectbox';
    Store.removeDbFiles(storePath);
  }
}

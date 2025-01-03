import 'package:uni/controller/local_storage/database-nosql/object_box_store.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/objectbox.g.dart';

/// Base class for ObjectBox database managers.
///
/// This class manages generic CRUD operations using ObjectBox.
abstract class NoSQLDatabase<T> {
  NoSQLDatabase(this.name);

  final String name;

  /// ObjectBox box (table) for the entity type `T`.
  Box<T>? box;

  /// Whether the session is persistent or not.
  bool? _persistentSession;

  /// Getter to determine if the session is persistent.
  Future<bool> get persistentSession async {
    _persistentSession ??= await PreferencesController.isSessionPersistent();
    return _persistentSession!;
  }

  /// Returns an instance of this database.
  Future<Box<T>> getBox() async {
    box ??= await initializeBox();
    return box!;
  }

  /// Initializes the ObjectBox store and box.
  Future<Box<T>> initializeBox() async {
    final storeInstance = await ObjectBoxStore.init();
    final store = storeInstance.store;
    return store.box<T>();
  }

  /// Saves the data to the database.
  Future<void> saveToDatabase(List<T> data) async {
    final bux = await getBox();
    bux
      ..removeAll()
      ..putMany(data);
  }

  /// Saves data only if the session is persistent.
  Future<void> saveIfPersistentSession(List<T> data) async {
    if (await persistentSession) {
      await saveToDatabase(data);
    }
  }

  /// Retrieves all objects of type `T`.
  Future<List<T>> getAll() async {
    final bux = await getBox();
    return bux.getAll();
  }

  /// Deletes all objects of type `T`.
  Future<void> deleteAll() async {
    final bux = await getBox();
    bux.removeAll();
  }
}

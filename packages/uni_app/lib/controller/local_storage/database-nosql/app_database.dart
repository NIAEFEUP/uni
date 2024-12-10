import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

/// Manages a generic database.
///
/// This class is the foundation for all other database managers.
///
///
/// TODO(thePeras): Auto migration script and add a key for last timeupdated?
abstract class NoSQLDatabase<T> {
  NoSQLDatabase(
    this.name, {
    this.version = 1,
  });

  /// An instance of this database.
  Box<T>? _db;

  /// The name of this database.
  String name;

  /// Whether the session is persistent or not.
  bool? _persistentSession;

  /// The version of this database.
  final int version;

  /// Getter to determine if the session is persistent.
  Future<bool> get persistentSession async {
    _persistentSession ??= await PreferencesController.isSessionPersistent();
    return _persistentSession!;
  }

  /// Returns an instance of this box
  Future<Box<T>> _getBox() async {
    _db ??= await _initializeBox();
    return _db!;
  }

  /// Saves the data to the database.
  Future<void> saveToDatabase(List<T> data) async {
    final db = await _getBox();
    await db.clear();
    await db.addAll(data);
  }

  /// Calls saveToDatabase if the session is persistent
  Future<void> saveIfPersistentSession(List<T> data) async {
    if (await persistentSession) {
      await saveToDatabase(data);
    }
  }

  Future<List<T>> getAll() async {
    final db = await _getBox();
    return db.values.toList();
  }

  Future<void> deleteAll() async {
    final db = await _getBox();
    await db.clear();
  }

  /// Initializes this database.
  Future<Box<T>> _initializeBox() async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return Hive.openBox<T>(name);
  }

  // TODO(thePeras): Why static?
  /// Removes the database called [name].
  static Future<void> removeDatabase(String name) async {
    await Hive.deleteBoxFromDisk(name);
  }

  /// Registers the adapters for this database.
  static void registerAdapters() {
    // Implement this method in the subclass
  }
}

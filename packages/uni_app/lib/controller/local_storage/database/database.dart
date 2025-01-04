import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/floor_occupation.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/objectbox.g.dart';

class Database {
  factory Database() {
    return _instance;
  }
  Database._internal();
  static final Database _instance = Database._internal();

  late final Store _store;
  Admin? _admin;

  late final Box<Exam> _examBox;
  late final Box<Lecture> _lectureBox;
  late final Box<CalendarEvent> _calendarBox;
  late final Box<CourseUnit> _courseUnitBox;
  late final Box<Course> _courseBox;
  late final Box<FloorOccupation> _libraryOccupationBox;
  late final Box<Reference> _referenceBox;
  late final Box<Restaurant> _restaurantBox;
  late final Box<Profile> _profileBox;

  List<Exam> get exams => _examBox.getAll();
  void saveExams(List<Exam> exams) => saveEntities(_examBox, exams);

  List<Lecture> get lectures => _lectureBox.getAll();
  void saveLectures(List<Lecture> lectures) =>
      saveEntities(_lectureBox, lectures);

  List<CalendarEvent> get calendarEvents => _calendarBox.getAll();
  void saveCalendarEvents(List<CalendarEvent> calendarEvents) =>
      saveEntities(_calendarBox, calendarEvents);

  List<CourseUnit> get courseUnits => _courseUnitBox.getAll();
  void saveCourseUnits(List<CourseUnit> courseUnits) =>
      saveEntities(_courseUnitBox, courseUnits);

  List<Course> get courses => _courseBox.getAll();
  void saveCourses(List<Course> courses) => saveEntities(_courseBox, courses);

  List<FloorOccupation> get libraryOccupations =>
      _libraryOccupationBox.getAll();
  void saveLibraryOccupations(List<FloorOccupation> libraryOccupations) =>
      saveEntities(_libraryOccupationBox, libraryOccupations);

  List<Reference> get references => _referenceBox.getAll();
  void saveReferences(List<Reference> references) =>
      saveEntities(_referenceBox, references);

  List<Restaurant> get restaurants => _restaurantBox.getAll();
  void saveRestaurants(List<Restaurant> restaurants) =>
      saveEntities(_restaurantBox, restaurants);

  Profile get profile =>
      _profileBox.isEmpty() ? Profile() : _profileBox.getAll().first;
  void saveProfile(Profile profile) => saveEntity(_profileBox, profile);

  /// Whether the session is persistent or not.
  bool? _persistentSession;
  Future<bool> get persistentSession async {
    _persistentSession ??= await PreferencesController.isSessionPersistent();
    return _persistentSession!;
  }

  Future<void> saveEntities<T>(Box<T> box, List<T> entities) async {
    if (await persistentSession) {
      box
        ..removeAll()
        ..putMany(entities);
    }
  }

  Future<void> saveEntity<T>(Box<T> box, T entity) async {
    if (await persistentSession) {
      box
        ..removeAll()
        ..put(entity);
    }
  }

  Future<void> init() async {
    final storePath = await _getDatabasePath();
    try {
      _store = await openStore(directory: storePath);
    } catch (err) {
      //TODO(thePeras): Better error handling
      if (err.toString().contains('ObjectBoxException')) {
        await remove();
        _store = await openStore(directory: storePath);
      } else {
        Logger().e(err);
      }
    } finally {
      _boxesInitialization();

      //TODO(thePeras): Check if is only runned in debug mode
      if (Admin.isAvailable()) {
        _admin = Admin(_store);
      }
    }
  }

  void _boxesInitialization() {
    _profileBox = _store.box<Profile>();
    _examBox = _store.box<Exam>();
    _lectureBox = _store.box<Lecture>();
    _calendarBox = _store.box<CalendarEvent>();
    _courseUnitBox = _store.box<CourseUnit>();
    _courseBox = _store.box<Course>();
    _libraryOccupationBox = _store.box<FloorOccupation>();
    _referenceBox = _store.box<Reference>();
    _restaurantBox = _store.box<Restaurant>();
  }

  void clear() {
    _profileBox.removeAll();
    _examBox.removeAll();
    _lectureBox.removeAll();
    _calendarBox.removeAll();
    _courseUnitBox.removeAll();
    _courseBox.removeAll();
    _libraryOccupationBox.removeAll();
    _referenceBox.removeAll();
    _restaurantBox.removeAll();
  }

  void close() {
    _store.close();
    _admin?.close();
  }

  Future<void> remove() async {
    final storePath = await _getDatabasePath();
    Store.removeDbFiles(storePath);
  }

  Future<String> _getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/database';
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

class RestaurantDatabase extends AppDatabase<List<Restaurant>> {
  RestaurantDatabase()
      : super(
          'restaurant.db',
          [createScript],
          onUpgrade: migrate,
          version: 2,
        );

  static const createScript = '''
          CREATE TABLE RESTAURANTS(
          id INTEGER PRIMARY KEY,
          ref TEXT,
          name TEXT,
          meals TEXT)
        ''';

  /// Get all restaurants and meals, if day is null, all meals are returned
  Future<List<Restaurant>> restaurants({DayOfWeek? day}) async {
    final db = await getDatabase();
    final restaurants = <Restaurant>[];

    await db.transaction((txn) async {
      final List<Map<String, dynamic>> restaurantMaps =
          await db.query('restaurants');

      for (final map in restaurantMaps) {
        final restaurant = Restaurant.fromJson(map);
        if (day != null) {
          restaurant.meals = {day: restaurant.getMealsOfDay(day)};
        }
        restaurants.add(restaurant);
      }
    });
    return filterPastMeals(restaurants);
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await getDatabase();
    final restaurants = <Restaurant>[];
    await db.transaction((txn) async {
      final List<Map<String, dynamic>> restaurantsFromDB =
          await txn.query('RESTAURANTS');
      for (final restaurantMap in restaurantsFromDB) {
        final restaurant = Restaurant.fromJson(restaurantMap);
        restaurants.add(restaurant);
      }
    });

    return filterPastMeals(restaurants);
  }

  /// Insert restaurant and meals in database
  Future<void> insertRestaurant(Transaction txn, Restaurant restaurant) async {
    final mealsJson = jsonEncode(restaurant.meals);
    final restaurantMap = restaurant.toJson();
    restaurantMap['meals'] = mealsJson;


    await txn.insert('RESTAURANTS', restaurantMap);
  }

  /// Deletes all restaurants and meals
  Future<void> deleteAll(Transaction txn) async {
    await txn.delete('restaurants');
  }

  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS RESTAURANTS')
      ..execute(createScript);
    await batch.commit();
  }

  @override
  Future<void> saveToDatabase(List<Restaurant> data) async {
    final db = await getDatabase();
    await db.transaction((transaction) async {
      await deleteAll(transaction);
      for (final restaurant in data) {
        await insertRestaurant(transaction, restaurant);
      }
    });
  }
}

List<Restaurant> filterPastMeals(List<Restaurant> restaurants) {
  final restaurantsCopy = List<Restaurant>.from(restaurants);
  // Hide past and next weeks' meals
  // (To replicate sigarra's behaviour for the GSheets meals)
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  final nextSunday = today.add(Duration(days: DateTime.sunday - now.weekday));

  for (final restaurant in restaurantsCopy) {
    for (final meals in restaurant.meals.values) {
      meals.removeWhere(
        (meal) => meal.date.isBefore(today) || meal.date.isAfter(nextSunday),
      );
    }
  }

  return restaurantsCopy;
}

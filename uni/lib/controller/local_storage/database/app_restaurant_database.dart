import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

class RestaurantDatabase extends AppDatabase {
  RestaurantDatabase()
      : super('restaurant.db', [
          '''
          CREATE TABLE RESTAURANTS(
          id INTEGER PRIMARY KEY,
          ref TEXT,
          name TEXT)
          ''',
          '''
          CREATE TABLE MEALS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          day TEXT,
          type TEXT,
          date TEXT,
          name TEXT,
          id_restaurant INTEGER,
          FOREIGN KEY (id_restaurant) REFERENCES RESTAURANTS(id))
          '''
        ]);

  /// Deletes all data, and saves the new restaurants
  Future<void> saveRestaurants(List<Restaurant> restaurants) async {
    final db = await getDatabase();
    await db.transaction((transaction) async {
      await deleteAll(transaction);
      for (final restaurant in restaurants) {
        await insertRestaurant(transaction, restaurant);
      }
    });
  }

  /// Get all restaurants and meals, if day is null, all meals are returned
  Future<List<Restaurant>> restaurants({DayOfWeek? day}) async {
    final db = await getDatabase();
    var restaurants = <Restaurant>[];

    await db.transaction((txn) async {
      final List<Map<String, dynamic>> restaurantMaps =
          await db.query('restaurants');

      restaurants = await Future.wait(
        restaurantMaps.map((map) async {
          final restaurantId = map['id'] as int;
          final meals = await getRestaurantMeals(txn, restaurantId, day: day);

          return Restaurant(
            restaurantId,
            map['name'] as String,
            map['ref'] as String,
            meals: meals,
          );
        }).toList(),
      );
    });

    return restaurants;
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await getDatabase();
    final restaurants = <Restaurant>[];
    await db.transaction((txn) async {
      final List<Map<String, dynamic>> restaurantsFromDB =
          await txn.query('RESTAURANTS');
      for (final restaurantMap in restaurantsFromDB) {
        final id = restaurantMap['id'] as int;
        final meals = await getRestaurantMeals(txn, id);
        final restaurant = Restaurant.fromMap(restaurantMap, meals);
        restaurants.add(restaurant);
      }
    });

    return filterPastMeals(restaurants);
  }

  Future<List<Meal>> getRestaurantMeals(
    Transaction txn,
    int restaurantId, {
    DayOfWeek? day,
  }) async {
    final whereArgs = <dynamic>[restaurantId];
    var whereQuery = 'id_restaurant = ? ';
    if (day != null) {
      whereQuery += ' and day = ?';
      whereArgs.add(toString(day));
    }

    //Get restaurant meals
    final List<Map<String, dynamic>> mealsMaps =
        await txn.query('meals', where: whereQuery, whereArgs: whereArgs);

    //Retrieve data from query
    final meals = mealsMaps.map((map) {
      final day = parseDayOfWeek(map['day'] as String);
      final type = map['type'] as String;
      final name = map['name'] as String;
      final format = DateFormat('d-M-y');
      final date = format.parseUtc(map['date'] as String);
      return Meal(type, name, day!, date);
    }).toList();

    return meals;
  }

  /// Insert restaurant and meals in database
  Future<void> insertRestaurant(Transaction txn, Restaurant restaurant) async {
    final id = await txn.insert('RESTAURANTS', restaurant.toJson());
    restaurant.meals.forEach((dayOfWeak, meals) async {
      for (final meal in meals) {
        await txn.insert('MEALS', meal.toMap(id));
      }
    });
  }

  /// Deletes all restaurants and meals
  Future<void> deleteAll(Transaction txn) async {
    await txn.delete('meals');
    await txn.delete('restaurants');
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

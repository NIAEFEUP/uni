import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

class RestaurantDatabase extends AppDatabase<List<Restaurant>> {
  RestaurantDatabase()
      : super(
          'restaurant.db',
          [
            '''
          CREATE TABLE RESTAURANTS(
          id INTEGER PRIMARY KEY,
          ref TEXT,
          namePt TEXT
					namePt TEXT)
          ''',
            '''
          CREATE TABLE MEALS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          day TEXT,
          type TEXT,
          date TEXT,
          namePt TEXT,
          nameEn TEXT,
          id_restaurant INTEGER,
          FOREIGN KEY (id_restaurant) REFERENCES RESTAURANTS(id))
          '''
          ],
        );

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
            map['namePt'] as String,
            map['nameEn'] as String,
            map['period'] as String,
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

    return restaurants;
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

    // Get restaurant meals
    final List<Map<String, dynamic>> mealsMaps =
        await txn.query('meals', where: whereQuery, whereArgs: whereArgs);

    // Retrieve data from query
    final meals = mealsMaps.map((map) {
      final day = parseDayOfWeek(map['day'] as String);
      final type = map['type'] as String;
      final namePt = map['namePt'] as String;
      final nameEn = map['nameEn'] as String;
      final format = DateFormat('d-M-y');
      final date = format.parseUtc(map['date'] as String);
      return Meal(type, namePt, nameEn, day!, date);
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

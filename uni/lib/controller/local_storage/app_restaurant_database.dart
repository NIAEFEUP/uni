import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

class RestaurantDatabase extends AppDatabase {
  RestaurantDatabase()
      : super('restaurant.db', [
          'CREATE TABLE RESTAURANTS(id INTEGER PRIMARY KEY, ref TEXT , name TEXT)',
          '''CREATE TABLE MEALS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          day TEXT,
          type TEXT,
          date TEXT,
          name TEXT,
          id_restaurant INTEGER,
          FOREIGN KEY (id_restaurant) REFERENCES RESTAURANTS(id))'''
        ]);

  /// Deletes all data, and saves the new restaurants
  void saveRestaurants(List<Restaurant> restaurants) async {
    final Database db = await getDatabase();
    db.transaction((transaction) async {
      await deleteAll(transaction);
      for (var restaurant in restaurants) {
        insertRestaurant(transaction, restaurant);
      }
    });
  }

  /// Get all restaurants and meals, if day is null, all meals are returned
  Future<List<Restaurant>> restaurants({DayOfWeek? day}) async {
    final Database db = await getDatabase();
    List<Restaurant> restaurants = [];

    await db.transaction((txn) async {
      final List<Map<String, dynamic>> restaurantMaps =
          await db.query('restaurants');

      restaurants = await Future.wait(restaurantMaps.map((map) async {
        final int restaurantId = map['id'];
        final List<Meal> meals =
            await getRestaurantMeals(txn, restaurantId, day: day);

        return Restaurant(restaurantId, map['name'], map['ref'], meals: meals);
      }).toList());
    });

    return restaurants;
  }

  Future<List<Meal>> getRestaurantMeals(Transaction txn, int restaurantId,
      {DayOfWeek? day}) async {
    final List<dynamic> whereArgs = [restaurantId];
    String whereQuery = 'id_restaurant = ? ';
    if (day != null) {
      whereQuery += ' and day = ?';
      whereArgs.add(toString(day));
    }

    //Get restaurant meals
    final List<Map<String, dynamic>> mealsMaps =
        await txn.query('meals', where: whereQuery, whereArgs: whereArgs);

    //Retrieve data from query
    final List<Meal> meals = mealsMaps.map((map) {
      final DayOfWeek? day = parseDayOfWeek(map['day']);
      final String type = map['type'];
      final String name = map['name'];
      final DateFormat format = DateFormat('d-M-y');
      final DateTime date = format.parse(map['date']);
      return Meal(name, type, day!, date);
    }).toList();

    return meals;
  }

  /// Insert restaurant and meals in database
  Future<void> insertRestaurant(Transaction txn, Restaurant restaurant) async {
    final int id = await txn.insert('RESTAURANTS', restaurant.toMap());
    restaurant.meals.forEach((dayOfWeak, meals) async{
      for (var meal in meals) {
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

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

import 'app_database.dart';

class RestaurantDatabase extends AppDatabase {
  RestaurantDatabase()
      : super('restaurant.db',
      ['CREATE TABLE RESTAURANTS(id INTEGER PRIMARY KEY, ref TEXT , name TEXT)',
      '''CREATE TABLE MEALS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          day TEXT,
          type TEXT,
          date TEXT,
          name TEXT,
          id_restaurant INTEGER,
          FOREIGN KEY (id_restaurant) REFERENCES RESTAURANTS(id))''']);

  /**
   * Delets all data, and saves the new restaurants
   */
  void saveRestaurants(List<Restaurant> restaurants) async{
    final Database db = await this.getDatabase();
    //final Batch batch = db.batch();
    deleteAll(db);
    restaurants.forEach((restaurant) {
      insertRestaurant(db, restaurant);
    });

  }

  /**
   * Get all restaurants and meals, if day is null, all meals are returned
   */
  Future<List<Restaurant>> restaurants(DayOfWeek day) async {
    final Database db = await this.getDatabase();

    final List<Map<String, dynamic>> restMaps = await db.query('restaurants');

    // Retrieve data from query.
    final List<Restaurant> restaurants =  List.generate(restMaps.length, (i) {
      return
        Restaurant(restMaps[i]['name'], restMaps[i]['ref'], restMaps[i]['id'] );
    });
    restaurants.forEach((rest) async {

      final List<dynamic> whereArgs = [rest.id];
      String whereQuery = 'id_restaurant = ? ';
      if(day != null){
        whereQuery += ' and day = ?';
        whereArgs.add(toString(day));
      }

      final List<Map<String, dynamic>> mealsMaps =
      await db.query('meals',
          where: whereQuery,
          whereArgs: whereArgs);

      //Retreive data from query
      final List<Meal> meals = List.generate(mealsMaps.length, (i) {
        final DayOfWeek day = parseDayOfWeek(mealsMaps[i]['day']);
        final String type = mealsMaps[i]['type'];
        final String name = mealsMaps[i]['name'];
        final DateFormat format = DateFormat('d-M-y');
        final DateTime date = mealsMaps[i]['date']!= null ?
                                    format.parse(mealsMaps[i]['date']) : null;
        return Meal(name, type, day, date, rest);
      });
      //Add meals to restaurants
      meals.forEach((meal) {
        rest.addMeal(meal);
      });
    });
    return restaurants;
  }
  /**
   * Insert restaurant and meals in database
   */
  Future<void> insertRestaurant(Database db, Restaurant restaurant) async{
    final int id = await db.insert('RESTAURANTS', restaurant.toMap());
    restaurant.id = id;
    final Iterable<DayOfWeek> days = restaurant.meals.keys;

    days.forEach((dayOfWeek) {
      final List<Meal> meals = restaurant.meals[dayOfWeek];
      meals.forEach((meal) {
        db.insert('MEALS', meal.toMap());
      });
    });

  }

  /**
   * Deletes all restaurants and meals
   */
  Future<void> deleteAll(Database db) async{
    db.delete('meals');
    db.delete('restaurants');
  }

}
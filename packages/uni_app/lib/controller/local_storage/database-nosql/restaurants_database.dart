import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/restaurant.dart';

class RestaurantsDatabase extends NoSQLDatabase<Restaurant> {
  RestaurantsDatabase() : super('restaurants');
}

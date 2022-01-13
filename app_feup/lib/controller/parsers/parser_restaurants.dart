import 'dart:collection';



import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

/**
 * Reads restaurants's menu from /feup/pt/CANTINA.EMENTASHOW
 */
Future<List<Restaurant>> getRestaurantsFromHtml(Response response) async {
  final document = parse(response.body);

  final Map<String, String> coursesStates =  HashMap();

  final List<Element> restaurantsHtml =
              document.querySelectorAll('#conteudoinner ul li > a');
  final List<Restaurant> restaurants = [];
  //Read restaurant's names
  restaurantsHtml.forEach( (restaurantHtml) {
      String name = restaurantHtml.innerHtml;
      String ref = restaurantHtml.attributes['href'];
      if(ref[0] == '#'){
        ref = ref.replaceAll('#', '');
      }
      Restaurant rest = Restaurant(name, ref, null);
      restaurants.add(rest);
  });

  //Add meals to restaurant
  restaurants.forEach( (restaurant) {
    Element referenceA = document.querySelector("a[name=\"${restaurant.reference}\"]");
    Element next = referenceA.nextElementSibling;
    while(next.attributes['name'] == null){
      next = next.nextElementSibling;
      if(next.classes.contains("dados")){
        //It's the menu table
        List<Element> rows = next.querySelectorAll("tr");
        //Check if is empty
        if(rows.length <= 1){
           break;
        }
        //Read headers
        List<Element> headersHtml = rows[0].querySelectorAll("th");
        List<String> headers = [];
        headersHtml.forEach((header) {
            headers.add(header.attributes['id']);
        });
        //Read rows
        rows.getRange(1, rows.length).forEach((row){
          DayOfWeek dayOfWeek;
          String type;
          DateTime date;

          List<Element> collumns = row.querySelectorAll("td");
          collumns.forEach((collumn) {
            String value = collumn.innerHtml;
            int i=0;
            String header = collumn.attributes['headers'];
            if(header == 'Data'){
              DayOfWeek d = parseDayOfWeek(value);
              DateFormat format = DateFormat('d-M-y');

              if(d == null){
                //It's a date
                date = format.parse(value);

              } else {
                dayOfWeek = d;
              }
            } else {
              DateFormat format = DateFormat('d-M-y');
              type = document.querySelector('#${header}').innerHtml;
              Meal meal = Meal(type, value,dayOfWeek, date, restaurant);
              restaurant.addMeal(meal);
            }
          });
        });

        break;
      }
    }
  });
  return restaurants;
}

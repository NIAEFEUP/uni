import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:provider/provider.dart';



class RestaurantPageCard extends StatefulWidget {
  final Restaurant restaurant;
  final Widget meals;

  RestaurantPageCard(this.restaurant, this.meals, {Key ? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => RestaurantPageCardState();
}

class RestaurantPageCardState extends State<RestaurantPageCard> {

  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<RestaurantProvider>(context).favoriteRestaurants.contains(widget.restaurant.name);
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(0x1c, 0, 0, 0),
                blurRadius: 7.0,
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 60.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin:
                          const EdgeInsets.only(top: 15, bottom: 10),
                          child: Text(
                            widget.restaurant.name,
                            style: (Theme.of(context).textTheme.headline6!)
                                .copyWith(
                                color:
                                Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: isFavorite ? const Icon(MdiIcons.heart) : const Icon(MdiIcons.heartOutline),
                          onPressed: ()  => setState((){
                            Provider.of<RestaurantProvider>(context, listen: false).toggleFavoriteRestaurant(widget.restaurant.name, Completer());
                          })),],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      bottom: 12.0,
                    ),
                    child: widget.meals,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

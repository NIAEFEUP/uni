import 'package:flutter/material.dart';

class RestaurantMenuItem extends StatelessWidget {
  const RestaurantMenuItem({
    super.key,
    required this.name,
    required this.icon});

  final String name;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, top: 8.0, bottom: 8.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: icon),
          Expanded(
            flex: 5,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
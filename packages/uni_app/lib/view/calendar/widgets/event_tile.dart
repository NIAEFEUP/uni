import 'package:flutter/material.dart';
class EventTile extends StatelessWidget {
  const EventTile({required this.text, super.key, this.onTap,});
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child:Text(
        text, style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DayOfWeekTab extends StatelessWidget {
  const DayOfWeekTab({
    super.key,
    required this.controller,
    required this.isSelected,
    required this.weekDay,
    required this.day,
  });

  final TabController controller;
  final bool isSelected;
  final String weekDay;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Tab(
      key: key,
      height: 50,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: 45,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromRGBO(177, 77, 84, 0.25)
                  : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekDay,
                  style: isSelected
                      ? const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromRGBO(102, 9, 16, 1))
                      : const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromRGBO(48, 48, 48, 1)),
                ),
                Text(
                  day,
                  style: isSelected
                      ? const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromRGBO(102, 9, 16, 1))
                      : const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromRGBO(48, 48, 48, 1)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
          body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 70,
              ),
              Flexible(
                child: ScheduleCard(
                    name: "Computer Laboratory",
                    acronym: "LCOM",
                    room: "B315",
                    type: "TP",
                    isActive: false,
                    teacherName: 'Pedro Souto'),
              )
            ],
          )
        ],
      )),
    );
  }
}

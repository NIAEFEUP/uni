import 'package:flutter/material.dart';
import 'package:uni_ui/average_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Timeline Example'),
            ),
            body: AverageBar(
                average: 14, completedCredits: 170, totalCredits: 190)));
  }
}

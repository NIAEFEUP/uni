import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AverageBar extends StatelessWidget {
  const AverageBar(
      {required this.average,
      required this.completedCredits,
      required this.totalCredits,
      required this.statusText,
      required this.averageText,
      super.key});

  final double average;
  final double completedCredits;
  final double totalCredits;
  final String statusText;
  final String averageText;

  String _displayNumber(double number) {
    return number == number.toInt()
        ? number.toInt().toString()
        : number.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(children: [
        ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: 1,
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: constraints.maxWidth * 0.25,
                height: 50,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(averageText),
                      Text(average.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))
                    ]))),
        SizedBox(width: constraints.maxWidth * 0.05),
        Container(
            width: constraints.maxWidth * 0.70,
            height: 50,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Tooltip(
                          message: "European Credit System",
                          child: Text("ECTS"),
                        ),
                        Text(
                            '${_displayNumber(completedCredits)}/${_displayNumber(totalCredits)}'),
                      ]),
                  LinearProgressIndicator(
                      minHeight: 8,
                      value: completedCredits / totalCredits,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  Text(statusText)
                ]))
      ]);
    });
  }
}

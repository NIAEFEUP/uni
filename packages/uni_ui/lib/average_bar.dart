import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AverageBar extends StatelessWidget {
  const AverageBar(
      {required this.average,
      required this.completedCredits,
      required this.totalCredits,
      super.key});

  final double average;
  final int completedCredits;
  final int totalCredits;

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
                      Text('Average'),
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
                        Text('ECTS'),
                        Text('$completedCredits/$totalCredits'),
                      ]),
                  LinearProgressIndicator(
                      minHeight: 8,
                      value: completedCredits / totalCredits,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  Text(completedCredits == totalCredits
                      ? "Concluído"
                      : "A frequentar")
                ]))
      ]);
    });
  }
}

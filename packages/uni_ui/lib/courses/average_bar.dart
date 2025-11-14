import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class AverageBar extends StatelessWidget {
  const AverageBar({
    required this.average,
    required this.completedCredits,
    required this.totalCredits,
    required this.statusText,
    required this.averageText,
    super.key,
  });

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            GenericCard(
              tooltip: 'Average',
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth * 0.25,
                  maxWidth: constraints.maxWidth * 0.30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(averageText),
                    Text(
                      average != 0 ? average.toString() : '---',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              padding: EdgeInsets.all(0),
              shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
              blurRadius: 2,
            ),
            SizedBox(width: constraints.maxWidth * 0.05),
            Container(
              width: constraints.maxWidth * 0.65,
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
                        '${_displayNumber(completedCredits)}/${_displayNumber(totalCredits)}',
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    minHeight: 8,
                    value:
                        totalCredits != 0 ? completedCredits / totalCredits : 1,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  Text(statusText),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

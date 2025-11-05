import 'package:flutter/widgets.dart';
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
            GenericSquircle(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondary,
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

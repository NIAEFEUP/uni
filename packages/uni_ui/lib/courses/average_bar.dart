import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/common_widgets/fade_in.dart';
import 'package:uni_ui/icons.dart';

class AverageBar extends StatelessWidget {
  const AverageBar({
    required this.average,
    required this.completedCredits,
    required this.totalCredits,
    required this.statusText,
    required this.averageText,
    required this.hiddenValueText,
    required this.showValueHint,
    required this.hideValueHint,
    required this.onToggleVisibility,
    this.hideSensitiveData = false,
    super.key,
  });

  final double average;
  final double completedCredits;
  final double totalCredits;
  final String statusText;
  final String averageText;
  final String hiddenValueText;
  final String showValueHint;
  final String hideValueHint;
  final VoidCallback onToggleVisibility;
  final bool hideSensitiveData;

  String _displayNumber(double number) {
    return number == number.toInt()
        ? number.toInt().toString()
        : number.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final averageValue = average != 0 ? average.toString() : '---';
    final credits =
        '${_displayNumber(completedCredits)}/${_displayNumber(totalCredits)}';
    final progress = totalCredits != 0
        ? (completedCredits / totalCredits).clamp(0.0, 1.0)
        : 1.0;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 350);
    final hint = hideSensitiveData ? showValueHint : hideValueHint;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.30,
              child: Semantics(
                button: true,
                excludeSemantics: true,
                label: averageText,
                value: hideSensitiveData ? hiddenValueText : averageValue,
                hint: hint,
                onTap: onToggleVisibility,
                child: GenericCard(
                  tooltip: hint,
                  onClick: onToggleVisibility,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  shadowColor: colors.shadow.withAlpha(0x25),
                  blurRadius: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(averageText),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 28 * textScale,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: hideSensitiveData
                                ? UniIcon(
                                    UniIcons.eyeHidden,
                                    size: 18,
                                    color: colors.onSecondary,
                                  )
                                : FadeIn(
                                    child: Text(
                                      averageValue,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.05),
            Expanded(
              child: Semantics(
                excludeSemantics: true,
                label: 'ECTS, $statusText',
                value: hideSensitiveData ? hiddenValueText : credits,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20 * textScale,
                        child: Row(
                          children: [
                            const Tooltip(
                              message: 'European Credit System',
                              child: Text('ECTS'),
                            ),
                            if (!hideSensitiveData) ...[
                              const SizedBox(width: 6),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: FadeIn(child: Text(credits)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: hideSensitiveData ? 0 : progress,
                        ),
                        duration: duration,
                        curve: Curves.easeInOutCubic,
                        builder: (context, value, child) =>
                            LinearProgressIndicator(
                              minHeight: 8,
                              value: value,
                              borderRadius: BorderRadius.circular(5),
                              backgroundColor: colors.secondary,
                              color: colors.onSecondary,
                            ),
                      ),
                      Text(statusText),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

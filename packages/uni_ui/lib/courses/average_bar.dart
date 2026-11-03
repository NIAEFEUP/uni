import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

class AverageBar extends StatefulWidget {
  const AverageBar({
    required this.average,
    required this.completedCredits,
    required this.totalCredits,
    required this.statusText,
    required this.averageText,
    required this.hiddenValueText,
    required this.showValueHint,
    required this.hideValueHint,
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
  final bool hideSensitiveData;

  @override
  State<AverageBar> createState() => _AverageBarState();
}

class _AverageBarState extends State<AverageBar> {
  late bool _averageHidden = widget.hideSensitiveData;
  late bool _creditsHidden = widget.hideSensitiveData;

  String _displayNumber(double number) {
    return number == number.toInt()
        ? number.toInt().toString()
        : number.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final average = widget.average != 0 ? widget.average.toString() : '---';
    final credits =
        '${_displayNumber(widget.completedCredits)}/${_displayNumber(widget.totalCredits)}';
    final progress = widget.totalCredits != 0
        ? (widget.completedCredits / widget.totalCredits).clamp(0.0, 1.0)
        : 1.0;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 280);
    final toggleAverage = widget.hideSensitiveData
        ? () => setState(() => _averageHidden = !_averageHidden)
        : null;
    final toggleCredits = widget.hideSensitiveData
        ? () => setState(() => _creditsHidden = !_creditsHidden)
        : null;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final hiddenIcon = UniIcon(
      UniIcons.eyeHidden,
      size: 18,
      color: colors.onSecondary,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.30,
              child: _PrivacyControl(
                label: widget.averageText,
                value: _averageHidden ? widget.hiddenValueText : average,
                hint: toggleAverage == null
                    ? null
                    : _averageHidden
                    ? widget.showValueHint
                    : widget.hideValueHint,
                onTap: toggleAverage,
                child: GenericCard(
                  tooltip: !widget.hideSensitiveData
                      ? widget.averageText
                      : _averageHidden
                      ? widget.showValueHint
                      : widget.hideValueHint,
                  onClick: toggleAverage,
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
                        child: Text(widget.averageText),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 28 * textScale,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _averageHidden
                                ? hiddenIcon
                                : Text(
                                    average,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
              child: _PrivacyControl(
                label: 'ECTS, ${widget.statusText}',
                value: _creditsHidden ? widget.hiddenValueText : credits,
                hint: toggleCredits == null
                    ? null
                    : _creditsHidden
                    ? widget.showValueHint
                    : widget.hideValueHint,
                onTap: toggleCredits,
                child: Tooltip(
                  message: !widget.hideSensitiveData
                      ? ''
                      : _creditsHidden
                      ? widget.showValueHint
                      : widget.hideValueHint,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    excludeFromSemantics: true,
                    onTap: toggleCredits,
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
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: _creditsHidden
                                          ? UniIcon(
                                              UniIcons.eyeHidden,
                                              size: 16,
                                              color: colors.onSecondary,
                                            )
                                          : Text(credits),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: _creditsHidden ? 0 : progress,
                              end: _creditsHidden ? 0 : progress,
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
                          Text(widget.statusText),
                        ],
                      ),
                    ),
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

class _PrivacyControl extends StatelessWidget {
  const _PrivacyControl({
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    required this.child,
  });

  final String label;
  final String value;
  final String? hint;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null ? true : null,
      excludeSemantics: true,
      label: label,
      value: value,
      hint: hint,
      onTap: onTap,
      child: child,
    );
  }
}

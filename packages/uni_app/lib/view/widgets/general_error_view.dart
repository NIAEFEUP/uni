import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';

class GeneralErrorView extends StatelessWidget {
  const GeneralErrorView({super.key, this.textColor});

  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            UniIcon(
              UniIcons.warning,
              size: 48,
              color: textColor ?? Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).unable_to_load_data,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor ?? Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight.isFinite) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(hasScrollBody: false, child: content),
            ],
          );
        }
        return content;
      },
    );
  }
}

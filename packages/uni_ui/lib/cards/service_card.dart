import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.name,
    this.statusWidget,
    required this.tooltip,
    this.function,
  });

  final void Function(BuildContext)? function;
  final String name;
  final Widget? statusWidget;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      margin: EdgeInsets.zero,
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
      blurRadius: 2,
      key: key,
      tooltip: tooltip,
      onClick: () => function?.call(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  ' \n ', // reserve 2 lines of space for the title
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.transparent),
                ),
              ),
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
              ),
            ],
          ),
          if (statusWidget != null) ...[
            const SizedBox(height: 10),
            statusWidget!,
            const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }
}

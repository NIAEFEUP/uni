import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.name,
    required this.acronym,
    required this.rooms,
    required this.type,
    this.startTime,
    this.isInvisible = false,
    this.showIcon = true,
    this.iconAction,
    this.examDay,
    this.examMonth,
  });

  final String name;
  final String acronym;
  final List<String> rooms;
  final String type;
  final String? startTime;
  final bool isInvisible;
  final bool showIcon;
  final Function()? iconAction;
  final String? examDay;
  final String? examMonth;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isInvisible ? 0.6 : 1.0,
      child: GenericCard(
        key: key,
        color: const Color.fromRGBO(255, 245, 243, 1), //TODO: Use theme
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        acronym,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall!,
                      ),
                      const SizedBox(width: 8),
                      Badge(
                        label: Text(type),
                        backgroundColor: BadgeColors.er,
                        textColor: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.clock(PhosphorIconsStyle.duotone),
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        startTime ?? "--:--",
                        style: Theme.of(context).textTheme.labelSmall!,
                      ),
                      if (examDay != null && examMonth != null) ...[
                        const SizedBox(width: 8),
                        PhosphorIcon(
                          PhosphorIcons.calendarBlank(PhosphorIconsStyle.duotone),
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$examDay $examMonth',
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ],
                      const SizedBox(width: 8),
                      if (rooms.isNotEmpty)
                        PhosphorIcon(
                          PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Colors.black, Colors.transparent],
                              stops: [0.8, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              rooms.join(" "),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (showIcon)
              IconButton(
                onPressed: iconAction ?? () {},
                icon: PhosphorIcon(
                  isInvisible
                      ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                      : PhosphorIcons.eyeSlash(PhosphorIconsStyle.duotone),
                  color: Theme.of(context).iconTheme.color,
                  size: 35,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

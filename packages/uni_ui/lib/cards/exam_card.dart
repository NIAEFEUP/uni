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
  });

  final String name;
  final String acronym;
  final List<String> rooms;
  final String type;
  final String? startTime;
  final bool isInvisible;
  final bool showIcon;
  final Function()? iconAction;

  static const Map<String, Color> examTypeColors = {
    'MT': BadgeColors.mt,
    'EN': BadgeColors.en,
    'ER': BadgeColors.er,
    'EE': BadgeColors.ee,
  };

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isInvisible ? 0.6 : 1.0,
      child: GenericCard(
        key: key,
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
                        style: Theme.of(context).textTheme.headlineMedium!,
                      ),
                      const SizedBox(width: 8),
                      Badge(
                        label: Text(type),
                        backgroundColor: examTypeColors[type],
                        textColor: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!,
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
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      const SizedBox(width: 8),
                      if (!rooms.isEmpty)
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
                              style: Theme.of(context).textTheme.bodyMedium,
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

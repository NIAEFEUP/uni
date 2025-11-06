import 'package:flutter/widgets.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:flutter/foundation.dart';
import 'package:uni_ui/theme.dart';
import 'package:uni_ui/common_widgets/circle_avatar.dart';

const double _avatarRadius = 20;

class RemainingInstructorsCard extends StatelessWidget {
  const RemainingInstructorsCard({
    super.key,
    required this.remainingCount,
    required this.profileImages,
    required this.tooltip,
  });

  final int remainingCount;
  final List<ImageProvider?> profileImages;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth / 2) - 4;

        return SizedBox(
          width: cardWidth,
          child: GenericCard(
            tooltip: tooltip,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            color: transparent,
            shadowColor: transparent,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: cardWidth * 0.7,
                    height: _avatarRadius * 2,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ...profileImages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final image = entry.value;
                          return Positioned(
                            left: index * _avatarRadius * 1.85,
                            child: CircleAvatar(
                              radius: _avatarRadius,
                              backgroundImage:
                                  image ??
                                  const AssetImage(
                                    'assets/images/profile_placeholder.png',
                                  ),
                            ),
                          );
                        }).toList(),
                        Positioned(
                          left: profileImages.length * _avatarRadius * 1.85,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: _avatarRadius,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '+$remainingCount',
                                    style: Theme.of(context).titleMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

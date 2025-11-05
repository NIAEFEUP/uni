import 'package:flutter/widgets.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';
import 'package:flutter/foundation.dart';

const double _avatarRadius = 20;

class InstructorCard extends StatelessWidget {
  const InstructorCard({
    super.key,
    required this.name,
    required this.isRegent,
    required this.instructorLabel,
    required this.regentLabel,
    required this.profileImage,
  });

  final String name;
  final bool isRegent;
  final String instructorLabel;
  final String regentLabel;
  final ImageProvider? profileImage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth / 2) - 4;
        return SizedBox(
          width: cardWidth,
          child: GenericCard(
            tooltip: name,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            shadowColor: transparent,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: CardTheme.of(context).color),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: _avatarRadius,
                    backgroundImage:
                        profileImage ??
                        const AssetImage(
                          'assets/images/profile_placeholder.png',
                        ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isRegent ? regentLabel : instructorLabel,
                          style: Theme.of(context).labelLarge,
                          overflow: TextOverflow.ellipsis,
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

import 'package:flutter/material.dart';

const double _avatarRadius = 20;
const double _instructorCardWidth = 165;

class RemainingInstructorsCard extends StatelessWidget {
  const RemainingInstructorsCard({
    super.key,
    required this.remainingCount,
    required this.remainingInstructorsLabel,
    required this.profileImages,
  });

  final int remainingCount;
  final String remainingInstructorsLabel;
  final List<ImageProvider?> profileImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _instructorCardWidth,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 245, 243, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: profileImages.length * _avatarRadius * 1.5,
              height: 40,
              child: Stack(
                children: profileImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final image = entry.value;
                  return Positioned(
                    left: index * _avatarRadius,
                    child: CircleAvatar(
                      radius: _avatarRadius,
                      backgroundImage: image ??
                          const AssetImage(
                              'assets/images/profile_placeholder.png'),
                    ),
                  );
                }).toList(),
              ),
            ),
            Flexible(
              child: Text(
                remainingInstructorsLabel,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

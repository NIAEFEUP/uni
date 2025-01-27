import 'dart:io';
import 'package:flutter/material.dart';

const double _avatarRadius = 20;
const double _instructorCardWidth = 165;

class InstructorCard extends StatelessWidget {
  const InstructorCard({
    super.key,
    required this.name,
    required this.isRegent,
    required this.onTap,
    required this.instructorLabel,
    required this.regentLabel,
    required this.profileImage,
  });

  final String name;
  final bool isRegent;
  final VoidCallback onTap;
  final String instructorLabel;
  final String regentLabel;
  final ImageProvider? profileImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _instructorCardWidth, 
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CardTheme.of(context).color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: _avatarRadius,
              backgroundImage: profileImage ??
                  const AssetImage('assets/images/profile_placeholder.png'),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 95, 
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  isRegent ? regentLabel : instructorLabel,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
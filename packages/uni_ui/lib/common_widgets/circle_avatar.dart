import 'package:flutter/widgets.dart';
import 'package:uni_ui/theme.dart';

class CircleAvatar extends StatelessWidget {
  const CircleAvatar({
    super.key,
    required this.radius,
    this.backgroundImage,
    this.backgroundColor = transparent,
    this.child,
  });

  final double radius;
  final ImageProvider? backgroundImage;
  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image = backgroundImage;
    if (image == null && child == null) {
      image = const AssetImage('assets/images/profile_placeholder.png');
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        image:
            image != null
                ? DecorationImage(image: image, fit: BoxFit.cover)
                : null,
        border: Border.all(color: Theme.of(context).primaryVibrant, width: 2),
      ),
      child: image == null ? ClipOval(child: child) : null,
    );
  }
}

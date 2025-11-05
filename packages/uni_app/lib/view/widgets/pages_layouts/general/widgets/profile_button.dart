import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/widgets/profile_image.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(5),
        shape: const CircleBorder(),
      ),
      onPressed:
          () => {
            Navigator.pushNamed(context, '/${NavigationItem.navProfile.route}'),
          },
      icon: const ProfileImage(radius: 20),
    );
  }
}

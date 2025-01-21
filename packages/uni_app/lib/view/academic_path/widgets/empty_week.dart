import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';

class EmptyWeek extends StatelessWidget {
  const EmptyWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: 'You have no classes this week.',
        labelTextStyle: TextStyle(fontSize: 15),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ModalPersonInfo extends StatelessWidget {
  const ModalPersonInfo({this.image, required this.name});

  final Image? image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60.0,
          backgroundColor: Colors.green, // TODO: CHANGE TO IMAGE
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}

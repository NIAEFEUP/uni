import 'package:flutter/material.dart';

class ModalPersonInfo extends StatelessWidget {
  const ModalPersonInfo({this.image, required this.name});

  final Image? image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60.0,
            backgroundImage: image?.image,
            backgroundColor: Colors.green,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.displaySmall,
          )
        ],
      ),
    );
  }
}

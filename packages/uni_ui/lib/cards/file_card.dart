import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
    );
  }
}

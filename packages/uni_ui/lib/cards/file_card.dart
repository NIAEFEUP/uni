import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    required this.filename,
    super.key,
  });

  final String filename;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 32),
      title: Text(filename),
      leading: UniIcon(
        UniIcons.file,
        color: Theme.of(context).iconTheme.color,
        size: 35,
      ),
    );
  }
}

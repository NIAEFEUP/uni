import 'package:flutter/material.dart';
import 'package:phosphor_flutter/src/phosphor_icon_data.dart';
import 'package:uni_ui/icons.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    required this.filename,
    required this.extension,
    super.key,
  });

  final String filename;
  final String extension;

  PhosphorDuotoneIconData getIconForExtension(String extension) {
    switch (extension) {
      case 'pdf':
        return UniIcons.filePdf;
      case 'doc':
      case 'docx':
        return UniIcons.fileDoc;
      case 'xls':
      case 'xlsx':
        return UniIcons.fileXls;
      case 'ppt':
      case 'pptx':
        return UniIcons.filePpt;
      default:
        return UniIcons.file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 32),
      title: Text(filename),
      leading: UniIcon(
        getIconForExtension(extension),
        color: Theme.of(context).iconTheme.color,
        size: 35,
      ),
    );
  }
}

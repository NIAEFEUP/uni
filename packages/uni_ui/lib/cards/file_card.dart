import 'package:flutter/material.dart';
import 'package:phosphor_flutter/src/phosphor_icon_data.dart';
import 'package:uni_ui/common_widgets/pulse_animation.dart';
import 'package:uni_ui/icons.dart';

class FileCard extends StatefulWidget {
  const FileCard({
    required this.filename,
    required this.extension,
    super.key,
  });

  final String filename;
  final String extension;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    return GestureDetector(
      onTap: () {
        _controller
          ..reset()
          ..repeat(reverse: true);
        // openFile(context, widget.file);
      },
      child: PulseAnimation(
        controller: _controller,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 32),
          title: Text(
            widget.filename,
            overflow: TextOverflow.ellipsis,
          ),
          leading: UniIcon(
            getIconForExtension(widget.extension),
            color: Theme.of(context).iconTheme.color,
            size: 35,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class FolderCard extends StatefulWidget {
  FolderCard({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title),
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: UniIcon(
          _isExpanded ? UniIcons.folderOpen : UniIcons.folderClosed,
          key: ValueKey<bool>(_isExpanded),
          color: Theme.of(context).iconTheme.color,
          size: 35,
        ),
      ),
      trailing: AnimatedRotation(
        duration: const Duration(milliseconds: 200),
        turns: _isExpanded ? 0.5 : 0,
        child: UniIcon(
          UniIcons.caretDown,
          key: ValueKey<bool>(_isExpanded),
          color: Theme.of(context).iconTheme.color,
          size: 35,
        ),
      ),
      shape: Border.all(color: Colors.transparent),
      onExpansionChanged: (isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      children: widget.children,
    );
  }
}

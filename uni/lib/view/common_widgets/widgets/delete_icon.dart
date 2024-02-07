import 'package:flutter/material.dart';

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({this.onDelete, super.key});

  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        alignment: Alignment.centerRight,
        height: 32,
        child: IconButton(
          iconSize: 22,
          icon: const Icon(Icons.delete),
          tooltip: 'Remover',
          onPressed: onDelete,
        ),
      ),
    );
  }
}

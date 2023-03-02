import 'dart:async';
import 'package:flutter/material.dart';

class RotatingImage extends StatefulWidget {
  final List<String> imagePaths;
  final double width;
  final double height;

  const RotatingImage({required this.imagePaths, required this.width, required this.height, Key? key}) : super(key: key);

  @override
  State<RotatingImage> createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _index = (_index + 1) % widget.imagePaths.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(widget.imagePaths[_index], height: widget.height, width: widget.width,);
  }
}

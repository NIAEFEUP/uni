import 'dart:math';
import 'package:flutter/material.dart';

class RandomImageWidget extends StatefulWidget {
  final List<Image> images;
  final double width;
  final double height;

  const RandomImageWidget({required this.images, required this.width, required this.height, Key? key}) : super(key: key);

  @override
  State<RandomImageWidget> createState() => _RandomImageWidgetState();
}

class _RandomImageWidgetState extends State<RandomImageWidget> {
  late final List<ImageProvider<Object>> _imageProviders;
  late final Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _imageProviders = widget.images.map((image) => image.image).toList();
  }

  ImageProvider<Object> _getRandomImageProvider() {
    final index = _random.nextInt(_imageProviders.length);
    return _imageProviders[index];
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _getRandomImageProvider(),
      width: widget.width,
      height: widget.height,
    );
  }
}

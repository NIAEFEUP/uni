import 'package:flutter/material.dart';

class ProfilePageRoute extends MaterialPageRoute<dynamic> {
  ProfilePageRoute({required super.builder});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);
}

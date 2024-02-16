import 'package:flutter/material.dart';
import 'package:uni/view/profile/profile.dart';

class ProfilePageRoute extends MaterialPageRoute<ProfilePageView> {
  ProfilePageRoute({required super.builder});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);
}

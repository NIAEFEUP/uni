import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class FacultyFilter extends StatelessWidget {
  const FacultyFilter({
    required this.faculties,
    required this.builder,
    super.key,
  });

  final List<String> faculties;
  final Widget Function(BuildContext context, List<String> authorizedFaculties)
      builder;

  @override
  Widget build(BuildContext context) {
    final authorizedFaculties = PreferencesController.getUserFaculties()
        .where(
          faculties.contains,
        )
        .toList();

    return authorizedFaculties.isNotEmpty
        ? builder(context, authorizedFaculties)
        : Container();
  }
}

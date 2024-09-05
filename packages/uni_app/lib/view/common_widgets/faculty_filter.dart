import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/session/flows/base/session.dart';

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
    final session = Provider.of<Session>(context);

    final authorizedFaculties = session.faculties
        .where(
          faculties.contains,
        )
        .toList();

    return authorizedFaculties.isNotEmpty
        ? builder(context, authorizedFaculties)
        : Container();
  }
}

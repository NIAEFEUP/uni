import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/riverpod/current_account_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/selected_account_faculty_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

/// Lets the user pick which of their faculties' accounts (fees,
/// transactions, payment links) is shown on the Current Account page.
class FacultySelector extends ConsumerWidget {
  const FacultySelector({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferred = ref.watch(selectedAccountFacultyProvider);
    final selectedFaculty = NetworkRouter.resolveFaculty(session, preferred);

    // SingleChildScrollView + Row is used instead of ListView to prevent row
    // from expanding vertically
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: session.faculties.map((faculty) {
          return _FacultyCard(
            faculty: faculty,
            selected: faculty == selectedFaculty,
            onTap: () {
              if (faculty == selectedFaculty) {
                return;
              }
              ref
                  .read(selectedAccountFacultyProvider.notifier)
                  .setFaculty(faculty);
              ref
                ..invalidate(currentAccountProvider)
                ..invalidate(profileProvider);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _FacultyCard extends StatelessWidget {
  const _FacultyCard({
    required this.faculty,
    required this.selected,
    required this.onTap,
  });

  final String faculty;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      onClick: onTap,
      color: selected
          ? null
          : Theme.of(context).colorScheme.secondary.withAlpha(120),
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
      tooltip: faculty.toUpperCase(),
      blurRadius: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 55),
          child: Column(
            children: [
              UniIcon(
                UniIcons.faculty,
                size: 32,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              Text(
                faculty.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.apply(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

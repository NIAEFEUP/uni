import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/widgets/profile_image.dart';

class ProfileOverview extends ConsumerWidget {
  const ProfileOverview({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider.select((value) => value.value!));

    final name = profile.name.split(' ');

    return FutureBuilder(
      future: ProfileNotifier.fetchOrGetCachedProfilePicture(session),
      builder:
          (context, profilePic) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ProfileImage(radius: 75),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                '${name.first} ${name.length > 1 ? name.last : ''}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                profile.email.split('@')[0],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Wrap(
                spacing: 8,
                children:
                    session.instances.map((instance) {
                      return Badge(
                        label: Text(
                          instance.name.toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/widgets/profile_image.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    return FutureBuilder(
      future: ProfileProvider.fetchOrGetCachedProfilePicture(
        session,
      ),
      builder: (context, profilePic) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ProfileImage(radius: 75),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
            profile.name,
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
            children: session.faculties.map((type) {
              return Badge(
                label: Text(
                  type.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

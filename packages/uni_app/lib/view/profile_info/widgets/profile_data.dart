import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/widgets/profile_image.dart';
import 'package:uni_ui/cards/data_list_tile.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).user_informations,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: (profile.profileInfo?.profileInfo ?? [])
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: entry.value[0],
                    text: entry.value[1],
                  ))
                  .toList(),
            ),
          ),

          Text(
            S.of(context).nationalities,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: (profile.profileInfo?.nationalities ?? [])
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: entry.value[0],
                    text: entry.value[1].capitalize(),
                  ))
                  .toList(),
            ),
          ),

          Text(
            S.of(context).identification_documents,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: (profile.profileInfo?.identification ?? [])
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: entry.value[0],
                    text: entry.value[1],
                  ))
                  .toList(),
            ),
          ),

          Text(
            S.of(context).contacts,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: (profile.profileInfo?.contacts ?? [])
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: entry.value[0],
                    text: entry.value[1],
                  ))
                  .toList(),
            ),
          ),

          Text(
            S.of(context).addresses,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: (profile.profileInfo?.addresses ?? [])
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: entry.value[0],
                    text: entry.value[1],
                  ))
                  .toList(),
            ),
          ),

        ],
      ),
    );
  }
}

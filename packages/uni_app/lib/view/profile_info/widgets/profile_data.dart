import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile_info.dart';
import 'package:uni_ui/cards/data_list_tile.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({required this.profileInfo, super.key});

  final ProfileInfo profileInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                  children: profileInfo.profileInfo.entries
                      .map(
                        (entry) =>
                            DataListTile(prefix: entry.key, text: entry.value),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).nationalities,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GenericCard(
                tooltip: S.of(context).user_informations,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: profileInfo.nationalities.entries
                      .map(
                        (entry) => DataListTile(
                          prefix: '${S.of(context).nationality} ${entry.key}',
                          text: entry.value,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).identification_documents,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GenericCard(
                tooltip: S.of(context).user_informations,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: profileInfo.identification.entries
                      .map(
                        (entry) =>
                            DataListTile(prefix: entry.key, text: entry.value),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).contacts,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GenericCard(
                tooltip: S.of(context).user_informations,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: profileInfo.contacts.entries
                      .map(
                        (entry) =>
                            DataListTile(prefix: entry.key, text: entry.value),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).addresses,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GenericCard(
                tooltip: S.of(context).user_informations,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: profileInfo.addresses.entries
                      .map(
                        (entry) =>
                            DataListTile(prefix: entry.key, text: entry.value),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

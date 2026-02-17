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
            'Informações Pessoais',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                DataListTile(
                  prefix: 'Nome',
                  text: profile.name,
                ),
                DataListTile(
                  prefix: 'Sexo',
                  text: profile.sex,
                ),
                DataListTile(
                  prefix: 'Data de Nascimento',
                  text: profile.birthDate,
                ),
                DataListTile(
                  prefix: 'Estado Civil',
                  text: profile.maritalStatus,
                ),
                DataListTile(
                  prefix: 'Nome do Pai',
                  text: profile.fatherName,
                ),
                DataListTile(
                  prefix: 'Nome da Mãe',
                  text: profile.motherName,
                ),
              ],
            ),
          ),

          Text(
            'Nacionalidades',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: profile.nationalities
                  .asMap()
                  .entries
                  .map((entry) => DataListTile(
                    prefix: '${entry.key + 1}',
                    text: entry.value.capitalize(),
                  ))
                  .toList(),
            ),
          ),

          Text(
            'Documentos de Identificação',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                DataListTile(
                  prefix: 'Identificação Fiscal',
                  text: profile.taxNumber,
                ),
                DataListTile(
                  prefix: 'Cartão de Cidadão',
                  text: profile.citizensCard,
                ),
                DataListTile(
                  prefix: 'Segurança Social',
                  text: profile.socialSecurity,
                ),
              ],
            ),
          ),

          Text(
            'Contactos Gerais',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                DataListTile(
                  prefix: 'Telemóvel',
                  text: profile.phoneNumber,
                ),
                DataListTile(
                  prefix: 'E-mail',
                  text: profile.emailAlt,
                ),
                DataListTile(
                  prefix: 'E-mail Instituicional',
                  text: profile.email,
                ),
              ],
            ),
          ),

          Text(
            'Moradas',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          GenericCard(
            tooltip: S.of(context).user_informations,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: profile.addressesInClassesTime
                  .map((value) => DataListTile(
                    prefix: 'Residência em tempo de aulas',
                    text: value,
                  ))
                  .toList()
                  +
                  profile.officialAddresses
                  .map((value) => DataListTile(
                    prefix: 'Residência Oficial',
                    text: value,
                  ))
                  .toList(),
            ),
          ),

        ],
      ),
    );
  }
}

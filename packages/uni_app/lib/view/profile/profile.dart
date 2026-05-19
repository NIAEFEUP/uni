import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/profile/profile_shimmer.dart';
import 'package:uni/view/profile/widgets/profile_info.dart';
import 'package:uni/view/profile/widgets/profile_overview.dart';
import 'package:uni/view/profile/widgets/settings.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class ProfilePageView extends ConsumerStatefulWidget {
  const ProfilePageView({super.key});

  @override
  ConsumerState<ProfilePageView> createState() => ProfilePageViewState();
}

/// Manages the 'Personal user page' section.
class ProfilePageViewState extends SecondaryPageViewState<ProfilePageView> {
  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        DefaultConsumer<Profile>(
          provider: profileProvider,
          builder: (context, ref, profile) => Column(
            children: [
              ProfileOverview(profile: profile),
              const ProfileInfoWidget(),
            ],
          ),
          hasContent: (profile) => profile.courses.isNotEmpty,
          loadingWidget: const ProfileCardShimmer(),
          nullContentWidget: Container(),
        ),
        GenericCard(
          tooltip: S.of(context).current_account,
          margin: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: ProfileListTile(
            icon: UniIcons.bank,
            title: S.of(context).current_account,
            subtitle: S.of(context).current_account_description,
            trailing: UniIcon(
              UniIcons.caretRight,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/${NavigationItem.navCurrentAccount.route}',
              );
            },
          ),
        ),
        const Settings(),
      ],
    );
  }

  @override
  Future<void> onRefresh() async {
    await ref.read(profileProvider.notifier).refreshRemote();
  }

  @override
  String? getTitle() {
    return null;
  }
}

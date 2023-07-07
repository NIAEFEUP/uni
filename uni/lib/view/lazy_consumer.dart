import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/profile_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

/// Wrapper around Consumer that ensures that the provider is initialized,
/// meaning that it has loaded its data from storage and/or remote.
/// The provider will not reload its data if it has already been loaded before.
/// There should be a SessionProvider and a ProfileProvider above this widget in
/// the widget tree to initialize the provider data the first time.
class LazyConsumer<T extends StateProviderNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;

  const LazyConsumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final sessionProvider = Provider.of<SessionProvider>(context);
      final profileProvider = Provider.of<ProfileProvider>(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final session = sessionProvider.session;
        final profile = profileProvider.profile;
        profileProvider.ensureInitialized(session, profile).then((value) =>
            Provider.of<T>(context, listen: false)
                .ensureInitialized(session, profile));
      });
    } catch (_) {
      // The provider won't be initialized
      // Should only happen in tests
    }

    return Consumer<T>(builder: (context, provider, _) {
      return builder(context, provider);
    });
  }
}

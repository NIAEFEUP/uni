import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/profile_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LazyConsumer<T extends StateProviderNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T, Widget?) builder;

  const LazyConsumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session =
        Provider.of<SessionProvider>(context, listen: false).session;
    final profile =
        Provider.of<ProfileProvider>(context, listen: false).profile;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<T>(context, listen: false)
          .ensureInitialized(session, profile);
    });

    return Consumer<T>(
      builder: builder,
    );
  }
}

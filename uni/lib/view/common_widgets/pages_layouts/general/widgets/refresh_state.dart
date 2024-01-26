import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

class RefreshState extends StatelessWidget {
  const RefreshState({required this.onRefresh, required this.child, super.key});

  final Future<void> Function(BuildContext) onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      onRefresh: () => ProfileProvider.fetchOrGetCachedProfilePicture(
        Provider.of<SessionProvider>(context, listen: false).state!,
        forceRetrieval: true,
      ).then((value) => onRefresh(context)),
      child: child,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

class RefreshState extends ConsumerStatefulWidget {
  const RefreshState({
    required this.onRefresh,
    required this.header,
    required this.body,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final Widget? header;
  final Widget body;

  @override
  ConsumerState<RefreshState> createState() => _RefreshStateState();
}

class _RefreshStateState extends ConsumerState<RefreshState> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.header != null) widget.header!,
        Expanded(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  notificationPredicate: (notification) =>
                      notification.metrics.axisDirection == AxisDirection.down,
                  onRefresh: () async {
                    unawaited(widget.onRefresh());
                    if (context.mounted) {
                      unawaited(ProfileNotifier.fetchOrGetCachedProfilePicture(
                        ref.read(sessionProvider).value!,
                      ));
                    }
                    return;
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                      maxHeight: viewportConstraints.maxHeight,
                    ),
                    child: widget.body,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

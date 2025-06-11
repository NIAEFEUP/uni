import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

class RefreshState extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (header != null) header!,
        Expanded(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RefreshIndicator(
                  key: GlobalKey<RefreshIndicatorState>(),
                  notificationPredicate:
                      (notification) =>
                          notification.metrics.axisDirection ==
                          AxisDirection.down,
                  onRefresh:
                      () => ProfileProvider.fetchOrGetCachedProfilePicture(
                        ref.read(sessionProvider).value!,
                      ).then((value) => onRefresh),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                      maxHeight: viewportConstraints.maxHeight,
                    ),
                    child: Builder(
                      builder:
                          (context) => GestureDetector(
                            onHorizontalDragEnd: (dragDetails) {
                              if (dragDetails.primaryVelocity! > 2) {
                                Scaffold.of(context).openDrawer();
                              }
                            },
                            child: body,
                          ),
                    ),
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

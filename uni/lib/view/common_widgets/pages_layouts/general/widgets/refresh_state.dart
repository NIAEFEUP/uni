import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

class RefreshState extends StatelessWidget {
  const RefreshState({
    required this.onRefresh,
    required this.header,
    required this.body,
    super.key,
  });

  final Future<void> Function(BuildContext) onRefresh;
  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        Expanded(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                child: RefreshIndicator(
                  key: GlobalKey<RefreshIndicatorState>(),
                  onRefresh: () =>
                      ProfileProvider.fetchOrGetCachedProfilePicture(
                    Provider.of<SessionProvider>(context, listen: false).state!,
                    forceRetrieval: true,
                  ).then((value) => onRefresh(context)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                      maxHeight: viewportConstraints.maxHeight,
                    ),
                    child: Builder(
                      builder: (context) => GestureDetector(
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

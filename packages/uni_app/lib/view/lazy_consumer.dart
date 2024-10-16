import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/bug_report/bug_report.dart';

/// Wrapper around Consumer that ensures that the provider is initialized,
/// meaning that it has loaded its data from storage and/or remote.
/// The provider will not reload its data if it has already been loaded before.
/// If the provider depends on the session, it will ensure that SessionProvider
/// and ProfileProvider are initialized before initializing itself.
/// This widget also falls back to loading or error widgets if
/// the provider data is not ready or has thrown an error, respectively.
class LazyConsumer<T1 extends StateProviderNotifier<T2>, T2>
    extends StatelessWidget {
  const LazyConsumer({
    required this.builder,
    required this.hasContent,
    required this.onNullContent,
    this.contentLoadingWidget,
    super.key,
  });

  final Widget Function(BuildContext, T2) builder;
  final bool Function(T2) hasContent;
  final Widget onNullContent;
  final Widget? contentLoadingWidget;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StateProviderNotifier<dynamic>? provider;
      try {
        provider = Provider.of<T1>(context, listen: false);
      } catch (_) {
        // The provider was not found. This should only happen in tests.
        Logger().e('LazyConsumer: ${T1.runtimeType} not found');
        return;
      }

      // If the provider fetchers depend on the session, make sure that
      // SessionProvider and ProfileProvider are initialized
      Future<void>? sessionFuture;
      try {
        sessionFuture = provider.dependsOnSession
            ? Provider.of<SessionProvider>(context, listen: false)
                .ensureInitialized(context)
                .then((_) async {
                if (context.mounted) {
                  await Provider.of<ProfileProvider>(context, listen: false)
                      .ensureInitialized(context);
                }
              })
            : Future(() {});
      } catch (err, st) {
        // In tests, it is ok to not find the startup providers:
        // all provider data should be mocked by the test itself.
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          Logger().e(
            'Failed to initialize startup providers: $err',
          );
          await Sentry.captureException(err, stackTrace: st);
        }
      }

      if (context.mounted) {
        await sessionFuture;
        if (context.mounted) {
          await provider.ensureInitialized(context);
        }
      }
    });

    return Consumer<T1>(
      builder: (context, provider, _) {
        return requestDependantWidget(context, provider);
      },
    );
  }

  Widget requestDependantWidget(BuildContext context, T1 provider) {
    final showContent =
        provider.state != null && hasContent(provider.state as T2);

    if (provider.requestStatus == RequestStatus.busy && !showContent) {
      return loadingWidget(context);
    } else if (provider.requestStatus == RequestStatus.failed) {
      return requestFailedMessage();
    }

    return showContent
        ? builder(context, provider.state as T2)
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: onNullContent,
            ),
          );
  }

  Widget loadingWidget(BuildContext context) {
    return contentLoadingWidget == null
        ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          )
        : Center(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).highlightColor,
              highlightColor: Theme.of(context).colorScheme.onPrimary,
              child: contentLoadingWidget!,
            ),
          );
  }

  Widget requestFailedMessage() {
    return FutureBuilder(
      future: Connectivity().checkConnectivity(),
      builder: (context, connectivitySnapshot) {
        if (!connectivitySnapshot.hasData) {
          return const Center(
            heightFactor: 3,
            child: CircularProgressIndicator(),
          );
        }

        if (connectivitySnapshot.data == ConnectivityResult.none) {
          return Center(
            heightFactor: 3,
            child: Text(
              S.of(context).check_internet,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Center(
                child: Text(
                  S.of(context).load_error,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Provider.of<T1>(context, listen: false)
                      .forceRefresh(context),
                  child: Text(S.of(context).try_again),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<BugReportPageView>(
                      builder: (context) => const BugReportPageView(),
                    ),
                  ),
                  child: Text(S.of(context).report_error),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class LazyConsumer<T1 extends StateProviderNotifier<T2>, T2> extends StatelessWidget {
  const LazyConsumer({
    required this.builder,
    required this.hasContent,
    required this.onNullContentText,
    this.optionalImage,
    this.contentLoadingWidget,
    this.mapper,
    super.key,
  });

  final Widget Function(BuildContext, T2) builder;
  final bool Function(T2) hasContent;
  final String onNullContentText;
  final Widget? optionalImage;
  final Widget? contentLoadingWidget;
  final T2 Function(T2)? mapper;

  static T2 _defaultMapper<T2>(T2 value) => value;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StateProviderNotifier<dynamic>? provider;
      try {
        provider = Provider.of<T1>(context, listen: false);
      } catch (_) {
        Logger().e('LazyConsumer: ${T1.runtimeType} not found');
        return;
      }

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
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          Logger().e('Failed to initialize startup providers: $err');
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
    final mappedState = provider.state != null
        ? (mapper ?? _defaultMapper)(provider.state as T2)
        : null;

    final showContent = provider.state != null && hasContent(mappedState as T2);

    if (provider.requestStatus == RequestStatus.busy && !showContent) {
      return loadingWidget(context);
    } else if (provider.requestStatus == RequestStatus.failed) {
      return requestFailedMessage();
    }

    return showContent
        ? builder(context, mappedState)
        : Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: onNullContent(context),
      ),
    );
  }

  Widget onNullContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            onNullContentText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ),
        if (optionalImage != null) optionalImage!,
      ],
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
                const SizedBox(width: 10),
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
    )
  }
}

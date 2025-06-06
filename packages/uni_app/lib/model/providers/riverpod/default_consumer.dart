import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef DefaultConsumerBuilder<T> =
    Widget Function(BuildContext context, WidgetRef ref, T value);

class DefaultConsumer<T> extends ConsumerWidget {
  const DefaultConsumer({
    super.key,
    required this.provider,
    required this.builder,
    this.loadingWidget,
    this.nullContentWidget,
  });

  final ProviderBase<AsyncValue<T?>> provider;
  final DefaultConsumerBuilder<T> builder;
  final Widget? loadingWidget;
  final Widget? nullContentWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);

    return asyncValue.when(
      loading:
          () =>
              loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (data) {
        if (data == null) {
          return nullContentWidget ??
              const Center(child: Text('No content available.'));
        }
        return builder(context, ref, data);
      },
    );
  }
}

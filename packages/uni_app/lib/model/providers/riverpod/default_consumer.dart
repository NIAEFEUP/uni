import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

typedef DefaultConsumerBuilder<T> =
    Widget Function(BuildContext context, WidgetRef ref, T value);

class DefaultConsumer<T> extends ConsumerWidget {
  const DefaultConsumer({
    super.key,
    required this.provider,
    required this.builder,
    required this.nullContentWidget,
    required this.hasContent,
    this.loadingWidget,
    this.errorWidget,
    this.mapper,
  });

  final ProviderBase<AsyncValue<T?>> provider;
  final DefaultConsumerBuilder<T> builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget nullContentWidget;
  final bool Function(T) hasContent;
  final T Function(T)? mapper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);

    return asyncValue.when(
      loading: () =>
          loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (err, _) => errorWidget ?? Center(child: Text('Error: $err')),
      data: (data) {
        if (data == null) {
          return nullContentWidget;
        }

        final mappedData = mapper != null ? mapper!(data) : data;

        if (!hasContent(mappedData)) {
          return nullContentWidget;
        }

        return builder(context, ref, mappedData);
      },
    );
  }
}

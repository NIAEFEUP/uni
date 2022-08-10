import 'dart:async';

class RefreshItemsAction {
  final Completer<void> completer;

  RefreshItemsAction({Completer? completer})
      : completer = completer ?? Completer<void>();
}

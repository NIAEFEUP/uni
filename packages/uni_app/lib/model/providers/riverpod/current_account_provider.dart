import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/parsers/parser_current_account.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final currentAccountProvider = FutureProvider.autoDispose((ref) async {
  final session = await ref.watch(sessionProvider.future);
  final fetcher = FeesFetcher();
  final parser = CurrentAccountParser(session: session);
  final result = await fetcher.extractCurrentAccount(session!, parser);
  return result;
});

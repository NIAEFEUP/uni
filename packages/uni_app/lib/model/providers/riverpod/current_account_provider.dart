import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/finances/current_account_fetcher.dart';
import 'package:uni/controller/parsers/parser_current_account.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final currentAccountProvider = FutureProvider.autoDispose((ref) async {
  final session = await ref.watch(sessionProvider.future);
  if (session == null) {
    throw Exception('Session is null — user may not be logged in');
  }

  final fetcher = CurrentAccountFetcher();
  final parser = CurrentAccountParser(session: session);

  try {
    final result = await fetcher.extractCurrentAccount(session, parser);
    return result;
  } catch (err) {
    rethrow;
  }
});
